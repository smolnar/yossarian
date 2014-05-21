Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: []
  artists: []
  attributeBindings: ['artists']

  contentDidChange: (->
    @set('content', @get('artists')[0..2])
  ).observes('artists').on('init')

  didInsertElement: ->
    $(document).ready =>
      @$().nivoSlider
        effect: 'slideInRight'
        slices: 15
        boxCols: 8
        boxRows: 4
        animSpeed: 400
        pauseTime: Math.random() * (20000 - 3000) + 3000
        directionNav: false
        controlNav: false
        pauseOnHover: true
        randomStart: true
