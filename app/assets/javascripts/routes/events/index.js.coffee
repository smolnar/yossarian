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
        @store.pushPayload('event', data)

        events = data.events.map (event) => @store.getById('event', event.id)

        controller.set('content', events)

        callback?()

  setupController: (controller) ->
    @loadData(controller)

  actions:
    reload: (callback) ->
      controller = @controllerFor('events')

      @loadData(controller, callback)
