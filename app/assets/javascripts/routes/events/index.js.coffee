Yossarian.EventsRoute = Ember.Route.extend
  loadData: (controller) ->
    ids = @store.all('event').map (event) -> event.get('id')

    $.getJSON '/api/events', except: ids, (data) =>
      @store.pushPayload('event', data)

      controller.set('location', latitude: 48.133346, longitude: 17.111111)
      controller.set('content', @store.all('event'))

  setupController: (controller) ->
    @loadData(controller)

  actions: {
    loadMore: ->
      @loadData(@controllerFor('events'))
  }
