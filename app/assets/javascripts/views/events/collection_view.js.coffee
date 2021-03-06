Yossarian.EventItemView = Ember.View.extend
  tagName: 'div'
  classNames: ['event']
  attributeBindings: ['class']

  mouseEnter: -> @open()
  mouseLeave: -> @close()
  click: -> @set('parentView.selected', @)

  didInsertElement: -> @$('[data-toggle="tooltip"]').tooltip()

  selectedDidChange: (->
    if @get('parentView.selected') == @ then @open() else @close()
  ).observes('parentView.selected')

  open: ->
    @$().find('.info').addClass('active')
    @$().find('.nivo-caption').fadeOut(400)
    @$().find('.nivoSlider').data('nivoslider')?.stop()

  close: ->
    @$().find('.info').removeClass('active')
    @$().find('.nivo-caption').fadeIn(400)
    @$().find('.nivoSlider').data('nivoslider')?.start()

Yossarian.EventsCollectionView = Ember.CollectionView.extend
  selected: null
  itemViewClass: Yossarian.EventItemView
