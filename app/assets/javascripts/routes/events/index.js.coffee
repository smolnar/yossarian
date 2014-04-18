Yossarian.EventsRoute = Ember.Route.extend
  setupController: (controller) ->
    $.getJSON '/api/events', (data) =>
      @store.pushPayload('event', data)

      controller.set('content', @store.all('event'))
