Yossarian.Router.map ->
  @resource 'events', path: '/'

Yossarian.Router.reopen location: 'hash'
