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
        if options.reload?
          @store.unloadAll('event')

        @store.pushPayload('event', data)

        controller.set('content', @store.all('event'))

  setupController: (controller) ->
    @loadData(controller)

  actions:
    reload: ->
      controller = @controllerFor('events')

      @loadData(controller, reload: true)

    loadMore: ->
      controller = @controllerFor('events')

      controller.set('currentPage', controller.get('currentPage') + 1)

      @loadData(controller)
