Yossarian.EventsRoute = Ember.Route.extend
  loadData: (controller) ->
    ids = @store.all('event').map (event) -> event.get('id')

    $.getJSON '/api/events', except: ids, (data) =>
      @store.pushPayload('event', data)

      controller.set('content', @store.all('event'))

  setupController: (controller) ->
    @loadData(controller)

  actions: {
    loadMore: ->
      @loadData(@controllerFor('events'))
  }
