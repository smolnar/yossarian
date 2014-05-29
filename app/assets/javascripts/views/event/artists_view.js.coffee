Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: []

  didInsertElement: ->
    @$().nivoSlider
      effect: 'slideInRight'
      animSpeed: 400
      pauseTime: Math.random() * (20000 - 3000) + 3000
      directionNav: false
      controlNav: false
      pauseOnHover: true
      startSlide: Math.round(Math.random() * 2)
