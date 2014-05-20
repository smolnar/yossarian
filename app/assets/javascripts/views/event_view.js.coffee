Yossarian.EventView = Ember.View.extend
  tagName: 'div'
  classNames: ['event']
  attributeBindings: ['class']

  mouseEnter: ->
    @$().find('.info').addClass('active')
    @$().find('.nivoSlider').data('nivoslider').stop()

  mouseLeave: ->
    @$().find('.info').removeClass('active')
    @$().find('.nivoSlider').data('nivoslider').start()
