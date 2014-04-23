#= require spec_helper

describe 'Factory.Definition', ->
  it 'defines field value', ->
    definition = new Factory.Definition 'user', {}, (f) ->
      f.name = 'Peter'

    attribute = definition.attributes.name

    expect(attribute.name).to.eql('name')
    expect(attribute.value()).to.eql('Peter')

  it 'defines field value as function', ->
    n = 0

    definition = new Factory.Definition 'user', {}, (f) ->
      f.name = -> "Peter ##{n += 1}"

    attribute = definition.attributes.name

    expect(attribute.name).to.eql('name')
    expect(attribute.value()).to.eql('Peter #1')
    expect(attribute.value()).to.eql('Peter #2')

  it 'defines field with a sequence', ->
    definition = new Factory.Definition 'user', {}, (f) ->
      @sequence 'email', (n) -> "peter_#{n}@parker.com"

    attribute = definition.attributes.email

    expect(attribute.name).to.eql('email')
    expect(attribute.value()).to.eql('peter_0@parker.com')
    expect(attribute.value()).to.eql('peter_1@parker.com')

  it 'defines field with a sequence within trait', ->
    definition = new Factory.Definition 'user', {}, (f) ->
      @sequence 'email', (n) -> "peter_#{n}@parker.com"

      @trait 'admin', ->
        @sequence 'email', (n) -> "admin_#{n}@parker.com"

    attribute = definition.attributes.email

    expect(attribute.name).to.eql('email')
    expect(attribute.value()).to.eql('peter_0@parker.com')
    expect(attribute.value()).to.eql('peter_1@parker.com')

    attribute = definition.traits.admin.email

    expect(attribute.name).to.eql('email')
    expect(attribute.value()).to.eql("admin_2@parker.com")

  it 'defines an association', ->
    definition = new Factory.Definition 'user', {}, (f) ->
      @association 'role'

    attribute = definition.attributes.role

    expect(attribute.name).to.eql('role')
    expect(attribute.target).to.eql('user')
    expect(attribute.params[0]).to.eql('role')
    expect(attribute.params.length).to.eql(1)

  it 'defines an association within trait', ->
    definition = new Factory.Definition 'user', {}, (f) ->
      @association 'role'

      @trait 'admin', ->
        @association 'role', name: 'admin'

    attribute = definition.attributes.role

    expect(attribute.name).to.eql('role')
    expect(attribute.target).to.eql('user')
    expect(attribute.params[0]).to.eql('role')
    expect(attribute.params.length).to.eql(1)

    attribute = definition.traits.admin.role

    expect(attribute.name).to.eql('role')
    expect(attribute.target).to.eql('user')
    expect(attribute.params[0]).to.eql('role')
    expect(attribute.params[1]).to.eql(name: 'admin')
    expect(attribute.params.length).to.eql(2)


  describe '#buildAttributes', ->
    beforeEach ->
      @builder = mock('Factory.Builder', create: -> )

    it 'builds attributes', ->
      definition = new Factory.Definition 'user', {}, (f) ->
        f.name = 'Peter'

        @sequence    'email', (n) -> "peter_#{n}@parker.com"
        @association 'permission'

      @record = mock(get: ->)

      @builder
        .expects('create')
        .withExactArgs('permission')
        .returns(@record.object)
        .once()

      @record.mock
        .expects('get')
        .withExactArgs('id')
        .returns(1)
        .once()

      attributes = {}
      callbacks = definition.buildAttributes(attributes)

      expect(attributes).to.eql(id: 0, name: 'Peter', email: 'peter_0@parker.com', permission: 1)
      expect(callbacks.length).to.eql(1)

    it 'builds attributes with traits', ->
      definition = new Factory.Definition 'user', {}, (f) ->
        f.name  = 'Peter'
        f.email = 'peter@parker.com'

        @trait 'as admin', (f) ->
          f.name = 'Admin'

      attributes = {}
      definition.buildAttributes(attributes, ['as admin'])

      expect(attributes).to.eql(id: 0, name: 'Admin', email: 'peter@parker.com')

describe 'Factory.Builder', ->
  describe '#build', ->
    beforeEach ->
      @definitions = mock('Factory.Definitions', of: ->)

    it 'builds definition', ->
      definition = new Factory.Definition 'user', {}, (f) ->
        f.name  = 'Peter'
        f.email = 'peter@parker.com'

      @definitions
        .expects('of')
        .withExactArgs('user')
        .returns(definition)
        .once()

      attributes = {}

      callbacks = Factory.Builder.build('user', attributes)

      expect(attributes).to.eql(id: 0, name: 'Peter', email: 'peter@parker.com')
      expect(callbacks.length).to.eql(0)

    it 'builds definition with custom params', ->
      definition = new Factory.Definition 'user', {}, (f) ->
        f.name  = 'Peter'
        f.email = 'peter@parker.com'

      @definitions
        .expects('of')
        .withExactArgs('user')
        .returns(definition)
        .once()

      attributes = { name: 'John' }

      callbacks = Factory.Builder.build('user', attributes)

      expect(attributes).to.eql(id: 0, name: 'John', email: 'peter@parker.com')
      expect(callbacks.length).to.eql(0)

  describe '#create', ->
    beforeEach ->
      @driver = mock('Factory.driver', create: (->), associationFor: (->))

    it 'creates record', ->
      Factory.define 'user', (f) ->
        f.name = 'Peter'
        f.email = 'peter@peter.com'

        @trait 'with permissions', (f) ->
          f.permission = 'super'
          f.role       = 'admin'

      @driver
        .expects('create')
        .withExactArgs('user', id: 0, name: 'Peter', email: 'peter@peter.com')
        .once()

      user = Factory.Builder.create 'user'

    it 'creates record with traits', ->
      Factory.define 'user', (f) ->
        f.name  = 'Peter'
        f.email = 'peter@peter.com'

        @trait 'with permissions', (f) ->
          f.permission = 'super'

        @trait 'with role', (f) ->
          f.role = 'admin'

      @driver
        .expects('create')
        .withExactArgs('user', id: 0, name: 'Peter', email: 'peter@peter.com', permission: 'super', role: 'admin')
        .once()

      user = Factory.Builder.create 'user', 'with permissions', 'with role'

    it 'creates record with custom parameters', ->
      Factory.define 'user', (f) ->
        f.name  = 'Peter'
        f.email = 'peter@peter.com'

        @trait 'with permissions', (f) ->
          f.permission = 'super'

      @driver
        .expects('create')
        .withExactArgs('user', id: 0, name: 'John', email: 'peter@peter.com', permission: 'basic')

      Factory.Builder.create 'user', 'with permission', name: 'John', permission: 'basic'

    it 'creates records with sequences', ->
      Factory.define 'user', (f) ->
        @sequence 'name',  (n) -> "Peter #{n}"
        @sequence 'email', (n) -> "peter_#{n}@peter.com"

        @trait 'with permissions', (f) ->
          f.permission = 'super'
          @sequence 'role', (n) -> "admin #{n}"

      @driver
        .expects('create')
        .withExactArgs('user', id: 0, name: 'Peter 0', email: 'peter_0@peter.com', permission: 'super', role: 'admin 0')
        .once()

      user = Factory.Builder.create 'user', 'with permissions'

      @driver.expects('create')
        .withExactArgs('user', id: 1, name: 'Peter 1', email: 'peter_1@peter.com', permission: 'super', role: 'admin 1')
        .once()

      user = Factory.Builder.create 'user', 'with permissions'

    it 'creates record with association', ->
      Factory.define 'user', (f) ->
        @sequence 'name',  (n) -> "Peter #{n}"
        @sequence 'email', (n) -> "peter_#{n}@peter.com"

        @association 'role', name: 'basic'

      Factory.define 'role', (f) ->
        f.name = 'super'

      @user = { id: 0, name: 'Peter 0', email: 'peter_0@peter.com', role: 0 }

      @driver.expects('create')
        .withExactArgs('user', id: 0, name: 'Peter 0', email: 'peter_0@peter.com', role: 0)
        .returns(@user)
        .once()

      @role = mock(get: ->)

      @role.mock
        .expects('get')
        .withExactArgs('id')
        .returns(0)
        .once()

      @driver
        .expects('create')
        .withExactArgs('role', id: 0, name: 'basic')
        .returns(@role.object)
        .once()

      @driver
        .expects('associationFor')
        .withExactArgs(@role.object, @user, 'user')
        .once()

      Factory.Builder.create 'user'

    it 'creates associations with custom object', ->
      Factory.define 'user', (f) ->
        @sequence 'name',  (n) -> "Peter #{n}"
        @sequence 'email', (n) -> "peter_#{n}@peter.com"

        @association 'role', name: 'basic'

      Factory.define 'role', (f) ->
        f.name = 'super'

      @role = mock(get: ->)

      @role.mock
        .expects('get')
        .withExactArgs('id')
        .returns(20)
        .once()

      @user = { id: 0, name: 'Peter 0', email: 'peter_0@peter.com', role: 20 }

      @driver
        .expects('create')
        .withExactArgs('user', id: 0, name: 'Peter 0', email: 'peter_0@peter.com', role: 20)
        .returns(@user)
        .once()

      @driver
        .expects('associationFor')
        .withExactArgs(@role.object, @user, 'user')
        .once()

      Factory.Builder.create 'user', role: @role.object

describe 'Factory.Attribute', ->
  describe '#build', ->
    it 'builds an attribute with value', ->
      attribute = new Factory.Attribute('user', 'Peter')

      expect(attribute.name).to.eql('user')
      expect(attribute.value()).to.eql('Peter')

      attributes = {}

      attribute.build(attributes)
      expect(attributes).to.eql(user: 'Peter')

    it 'builds an attribute with function', ->
      n = 0

      attribute = new Factory.Attribute('user', -> "Peter ##{n += 1}")

      expect(attribute.name).to.eql('user')

      attributes = {}

      attribute.build(attributes)
      expect(attributes).to.eql(user: 'Peter #1')

      attributes = {}

      attribute.build(attributes)
      expect(attributes).to.eql(user: 'Peter #2')

describe 'Factory.Association', ->
  describe '#build', ->
    beforeEach ->
      @driver  = mock('Factory.driver', create: (->), associationFor: (->))
      @builder = mock('Factory.Builder', create: ->)

    it 'builds an association with new record', ->
      @parent = mock(get: ->)
      @child  = mock(get: ->)

      association = new Factory.Association('role', 'user', ['role'])

      @builder
        .expects('create')
        .withExactArgs('role')
        .returns(@parent.object)
        .once()

      @parent.mock
        .expects('get')
        .withExactArgs('id')
        .returns(1)
        .once()

      @driver
        .expects('associationFor')
        .withExactArgs(@parent.object, @child.object, 'user')
        .once(0)

      attributes = {}
      callback = association.build(attributes)

      expect(attributes).to.eql(role: 1)
      expect(typeof callback).to.eql('function')

      callback(@child.object)

    it 'builds an association with custom attributes', ->
      @parent = mock(get: ->)
      @child  = mock(get: ->)

      association = new Factory.Association('role', 'user', ['role', 'as admin', name: 'Admin'])

      @builder
        .expects('create')
        .withExactArgs('role', 'as admin', name: 'Admin')
        .returns(@parent.object)
        .once()

      @parent.mock
        .expects('get')
        .withExactArgs('id')
        .returns(1)
        .once()

      @driver
        .expects('associationFor')
        .withExactArgs(@parent.object, @child.object, 'user')
        .once()

      attributes = {}
      callback = association.build(attributes)

      expect(attributes).to.eql(role: 1)
      expect(typeof callback).to.eql('function')

      callback(@child.object)

    it 'builds an association with existing record', ->
      @parent = mock(get: ->)
      @child  = mock(get: ->)

      association = new Factory.Association('role', 'user', ['role', name: 'Admin'])

      @parent.mock
        .expects('get')
        .withExactArgs('id')
        .returns(1)
        .once()

      @driver
        .expects('associationFor')
        .withExactArgs(@parent.object, @child.object, 'user')
        .once()

      attributes = { role: @parent.object }
      callback = association.build(attributes)

      expect(attributes).to.eql(role: 1)
      expect(typeof callback).to.eql('function')

      callback(@child.object)

describe 'Factory', ->
  describe '#define', ->
    it 'creates definition for factory', ->
      Factory.define 'user', (f) ->
        f.name = 'Peter'
        f.email = 'peter@peter.com'

      definition = Factory.Definitions.of 'user'

      expect(definition.name).to.eql('user')
      expect(definition.type).to.eql('user')
      expect(definition.attributes.name.value()).to.eql('Peter')
      expect(definition.attributes.email.value()).to.eql('peter@peter.com')

    it 'creates definition with traits', ->
      Factory.define 'user', (f) ->
        f.name = 'Peter'
        f.email = 'peter@peter.com'

        @trait 'with permissions', (f) ->
          f.permission = 'super'
          f.role       = 'admin'

      definition = Factory.Definitions.of 'user'

      expect(definition.name).to.eql('user')
      expect(definition.type).to.eql('user')
      expect(definition.attributes.name.value()).to.eql('Peter')
      expect(definition.attributes.email.value()).to.eql('peter@peter.com')
      expect(definition.traits['with permissions'].permission.value()).to.eql('super')
      expect(definition.traits['with permissions'].role.value()).to.eql('admin')

  describe '#build', ->
    beforeEach ->
      @builder = mock('Factory.Builder', create: ->)

    it 'builds an record', ->
      @builder
        .expects('create')
        .withExactArgs('user', 'trait 1', 'trait 2', name: 'Peter')
        .once()

      Factory.build('user', 'trait 1', 'trait 2', name: 'Peter')

  describe '#create', ->
    beforeEach ->
      @builder = mock('Factory.Builder', create: ->)
      @driver  = mock('Factory.driver', save: ->)

    it 'creates an record', ->
      @record = { id: 1, name: 'Peter' }

      @builder
        .expects('create')
        .withExactArgs('user', 'trait 1', 'trait 2', name: 'Peter')
        .returns(@record)
        .once()

      @driver
        .expects('save')
        .withExactArgs(@record)
        .returns(@record)

      Factory.create('user', 'trait 1', 'trait 2', name: 'Peter')
