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
      pauseTime: Math.random() * (10000 - 3000) + 5000
      directionNav: false
      controlNav: false
      pauseOnHover: true
