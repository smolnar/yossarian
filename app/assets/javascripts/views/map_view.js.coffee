Yossarian.MapView = Ember.View.extend
  map: null
  tagName: 'div'

  didInsertElement: ->
    @_super()

    @set('map', new Yossarian.Map(id: @get('map'), element: @$().attr('id')))

  centerDidChange: (->
    @get('map').setCenter(@get('center'))
  ).observes('center')

  contentDidChange: (->
    @get('events').forEach (event) => @get('map').addEvent(event)
  ).observes('events.@each')
