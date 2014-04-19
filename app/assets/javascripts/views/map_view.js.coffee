Yossarian.MapView = Ember.View.extend
  map: null
  tagName: 'div'

  didInsertElement: ->
    @_super()

    @set('map', new Yossarian.Map(id: 'smolnar.i13lcpd1', element: @$().attr('id')))
