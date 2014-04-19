Yossarian.Map = Ember.Object.extend
  id:      null
  element: null

  init: (options) ->
    @set('id', options.id)
    @set('element', options.element)

    @bind()

  bind: ->
    Yossarian.map = L.mapbox.map(@get('element'), @get('id')).setView([37.9, -77], 5)
