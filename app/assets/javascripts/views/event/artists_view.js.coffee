Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: null
  artists: null

  contentDidChange: (->
    @set('content', @get('artists').toArray().shuffle()) if @get('artists')
  ).observes('artists').on('init')

  didInsertElement: ->
    @$().nivoSlider
      effect: 'slideInRight'
      animSpeed: 400
      pauseTime: Math.random() * (20000 - 3000) + 3000
      directionNav: false
      controlNav: false
      pauseOnHover: true
