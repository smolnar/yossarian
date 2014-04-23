class window.Factory
  @driver: null

  @find: (name, params) ->
    Factory.driver.find(name, params)

  @build: ->
    Factory.Builder.create.apply(null, arguments)

  @create: ->
    record = Factory.build.apply(null, arguments)

    Factory.driver.save(record)

    record

  @define: ->
    name     = arguments[0]
    options  = if typeof arguments[1] == 'object' then arguments[1] else {}
    callback = arguments[arguments.length - 1]

    Factory.Definitions.add(name, new Factory.Definition(name, options, callback))

class window.Factory.EmberStoreDriver
  @store: null

  @create: (type, attributes) ->
    EmberStoreDriver.store.push(type, attributes)

  @find: (type, params) ->
    EmberStoreDriver.store.all(name, params)

  @save: (record) ->
    record.save()

    record

  @associationFor: (parent, child, target) ->
    relation = Ember.Inflector.inflector.pluralize(target)

    unless parent.get(relation)
      throw new Error("Did you specify relation hasMany #{relation} in #{parent.constructor.toString()}?")

    parent.get(relation).pushObject(child)


class window.Factory.Builder
  @build: (type, attributes, traits) ->
    definition = Factory.Definitions.of(type)

    throw new Error("There is not definition for #{type}") unless definition

    definition.buildAttributes(attributes, traits)

  @create: ->
    params = Factory.Parser.parse(arguments)

    type       = params.type
    traits     = params.traits
    attributes = params.attributes

    callbacks = Factory.Builder.build(type, attributes, traits)

    record = Factory.driver.create(type, attributes)

    callback(record) for callback in callbacks

    record

class window.Factory.Parser
  @parse: (params) ->
    type       = params[0]
    traits     = []
    attributes = {}

    for param in Array.prototype.slice.call(params, [1, params.length - 1])
      if typeof(param) == 'string'
        traits.push param
      else
        $.extend(attributes, param)

    type: type, traits: traits, attributes: attributes

class window.Factory.Definitions
  @definitions: {}

  @add: (name, definition) ->
    Factory.Definitions.definitions[name] = definition

  @of: (name) ->
    Factory.Definitions.definitions[name]

class window.Factory.Attribute
  constructor: (name, object) ->
    @name   = name
    @object = object

  value: ->
    if typeof(@object) == 'function' then @object() else @object

  build: (attributes) ->
    attributes[@name] = @value() unless typeof(attributes[@name]) != 'undefined'

    null

class window.Factory.Association
  constructor: (name, target, params) ->
    @name   = name
    @target = target
    @params = params

  build: (attributes) ->
    parent = null

    if attributes[@name]
      parent = attributes[@name]
    else
      parent = Factory.Builder.create.apply(null, @params)

    # TODO (smolnar) consider using _id notation as well
    attributes[@name] = parent.get('id')

    (child) => Factory.driver.associationFor(parent, child, @target)

class window.Factory.Definition
  constructor: (name, options, callback) ->
    @name       = name
    @type       = options.type or name
    @callback   = callback
    @attributes = {}
    @traits     = {}
    @sequences  = {}

    @proxy = new Factory.Definition.Proxy(@, @attributes)

    @proxy.define ->
      @sequence 'id', (n) -> n

    @proxy.define(@callback)

  buildAttributes: (result, traits) ->
    callbacks  = []
    traits    ?= []
    attributes = {}

    for name, attribute of @attributes
      attributes[name] = attribute

    for trait in traits
      for name, attribute of @traits[trait]
        attributes[name] = attribute

    for _, attribute of attributes
      callback = attribute.build(result)

      callbacks = callbacks.concat(callback) if callback

    callbacks

class window.Factory.Definition.Proxy
  constructor: (base, attributes) ->
    @base       = base
    @attributes = attributes

  define: (callback) ->
    definitions = {}

    callback.call(@, definitions)

    for name, value of definitions
      @attributes[name] = new Factory.Attribute(name, value)

    @attributes

  trait: (name, callback) ->
    @proxy = new Factory.Definition.Proxy(@base, {})

    @proxy.define(callback)

    @base.traits[name] = @proxy.attributes

  sequence: (name, callback) ->
    @define (f) ->
      f[name] = =>
        result = callback(@base.sequences[name] ?= 0)

        @base.sequences[name] += 1

        result

  association: (name) ->
    @attributes[name] = new Factory.Association(name, @base.type, arguments)
