Yossarian.EventsRoute = Ember.Route.extend
  loadData: (controller, options) ->
    options ?= {}

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

  setupController: (controller) ->
    @loadData(controller)

  actions:
    reload: ->
      controller = @controllerFor('events')

      @loadData(controller)
