Yossarian.Map = Ember.Object.extend
  id:      null
  element: null

  init: (options) ->
    @set('id', options.id)
    @set('element', options.element)

    @bind()

  addEvent: (event) ->
    layer = @addMarker [event.get('venue_longitude'), event.get('venue_latitude')], event: event
    view  = Ember.View.create(template: Ember.TEMPLATES['events/marker'], controller: event)

    layer.bindPopup(view.renderToBuffer().buffer, closeButton: true, minWidth: 320)

  addMarker: (coordinates, properties) ->
    layer = L.mapbox.featureLayer
      type: 'Feature'
      geometry:
        type: 'Point',
        coordinates: coordinates
      properties: properties

    layer.addTo(@get('map'))

    layer

  bind: ->
    @set('map', L.mapbox.map(@get('element'), @get('id')))

  setCenter: (position) ->
    @get('map').setView([position.latitude, position.longitude], 5)
