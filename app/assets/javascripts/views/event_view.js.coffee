Yossarian.EventView = Ember.View.extend
  tagName: 'div'
  classNames: ['event']
  attributeBindings: ['class']

  mouseEnter: ->
    @$().find('.info').addClass('open')
    @$().find('.nivoSlider').data('nivoslider').stop()

  mouseLeave: ->
    @$().find('.info').removeClass('open')
    @$().find('.nivoSlider').data('nivoslider').start()
