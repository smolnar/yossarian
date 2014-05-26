Yossarian.EventsRoute = Ember.Route.extend
  loadData: (controller, callback) ->
    $.ajax
      type: 'POST'
      url: '/api/v1/events/search'
      data:
        q: controller.get('query')
        tags: controller.get('selectedTags')
        countries: controller.get('selectedCountries')
        page: controller.get('currentPage')
      success: (data) =>
        @store.unloadAll('event')
        @store.pushPayload('event', data)

        controller.set('content', @store.all('event'))
        callback()

  setupController: (controller) ->
    @loadData(controller)

  actions:
    reload: (callback) ->
      controller = @controllerFor('events')

      @loadData(controller, callback)
