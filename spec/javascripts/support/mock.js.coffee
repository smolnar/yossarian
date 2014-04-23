window.mock = ->
  if typeof(arguments[0]) == 'string'
    mockConstant.apply(null, arguments)
  else
    mockObject.apply(null, arguments)

window.mockObject = (attributes) ->
  mock = sinon.mock(attributes)

  afterEach -> mock.verify()

  object: attributes, mock: mock

window.mockConstant = (name, attributes) ->
  mock = sinon.mock(attributes)

  object     = window
  namespaces = name.split('.')

  for namespace in namespaces[0..namespaces.length - 2]
    object = object[namespace]

  namespace = namespaces.reverse()[0]

  value = object[namespace]
  object[namespace] = attributes

  afterEach ->
    mock.verify()

    object[namespace] = value

  mock
