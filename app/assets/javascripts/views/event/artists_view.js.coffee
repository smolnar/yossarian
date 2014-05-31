Yossarian.EventArtistView = Ember.View.extend
  tagName: 'img'
  attributeBindings: ['src', 'title']

  preload: ->
    @set('src', @get('content.image.image.large.url'))
    @set('title', @get('content.name'))

Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: []
  currentItem: null
  itemViewClass: Yossarian.EventArtistView

  didInsertElement: ->
    views = @get('childViews')

    view.preload() for view in views[0..2]

    for view in views[3..(views.length - 1)]
      ((view) -> setTimeout (-> view.preload()), 3000)(view)

    setTimeout (=> @initilizeSlider()), 100

  initilizeSlider: ->
    @$().nivoSlider
      effect: 'slideInRight'
      animSpeed: 400
      pauseTime: Math.random() * (20000 - 3000) + 3000
      directionNav: false
      controlNav: false
      pauseOnHover: true
      startSlide: Math.round(Math.random() * 2)
