Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName:    'ul'
  content:    []

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
