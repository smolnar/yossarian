Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: []
  artists: []
  attributeBindings: ['artists']

  contentDidChange: (->
    @set('content', @get('artists'))
  ).observes('artists').on('init')

  didInsertElement: ->
    @$().nivoSlider
      effect: 'slideInRight'
      animSpeed: 400
      pauseTime: Math.random() * (20000 - 3000) + 3000
      directionNav: false
      controlNav: false
      pauseOnHover: true
