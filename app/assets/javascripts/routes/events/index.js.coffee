Yossarian.EventsRoute = Ember.Route.extend
  loadData: (controller) ->
    ids = @store.all('event').map (event) -> event.get('id')

    $.ajax
      type: 'POST'
      url: '/api/v1/events/search'
      data:
        q: controller.get('query')
        except: ids
        tags: controller.get('selectedTags')
        countries: controller.get('selectedCountries')
      success: (data) =>
        @store.pushPayload('event', data)

        controller.set('content', @store.all('event'))

  setupController: (controller) ->
    @loadData(controller)

  actions:
    loadMore: ->
      @loadData(@controllerFor('events'))
