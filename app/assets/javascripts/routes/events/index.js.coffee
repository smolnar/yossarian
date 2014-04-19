Yossarian.EventsRoute = Ember.Route.extend
  setupController: (controller) ->
    $.getJSON '/api/events', (data) =>
      @store.pushPayload('event', data)

      controller.set('location', latitude: 48.133346, longitude: 17.111111)
      controller.set('content', @store.all('event'))
