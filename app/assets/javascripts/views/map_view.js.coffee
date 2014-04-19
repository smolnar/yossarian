Yossarian.MapView = Ember.View.extend
  map: null
  tagName: 'div'

  didInsertElement: ->
    @_super()

    @set('map', new Yossarian.Map(id: 'smolnar.i14e2n90', element: @$().attr('id')))

  centerDidChange: (->
    @get('map').setCenter(@get('center'))
  ).observes('center')

  contentDidChange: (->
    @get('events').forEach (event) => @get('map').addEvent(event)
  ).observes('events.@each')
