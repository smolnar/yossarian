Yossarian.EventArtistView = Ember.View.extend
  tagName: 'img'
  attributeBindings: ['src', 'title']

  preload: ->
    @set('src', @get('content.image.image.large.url'))
    @set('title', @get('content.name'))

Yossarian.EventArtistsView = Ember.CollectionView.extend
  tagName: 'div'
  content: []
  nextSlideView: null
  itemViewClass: Yossarian.EventArtistView

  didInsertElement: ->
    views = @get('childViews')

    view.preload() for view in views[0..2]

    @set('nextSlideView', views[2])
    @preloadNextSlideView()

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
      afterChange: => @preloadNextSlideView()

  preloadNextSlideView: ->
    views = @get('childViews')
    index = views.indexOf(@get('nextSlideView')) + 1

    return if index >= views.length

    @set('nextSlideView', views[index])
    @get('nextSlideView').preload()
