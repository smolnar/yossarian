Yossarian.EventView = Ember.View.extend
  tagName: 'li'

  mouseEnter: ->
    @$().find('.info').addClass('open')
    @$().find('.nivoSlider').data('nivoslider').stop()

  mouseLeave: ->
    @$().find('.info').removeClass('open')
    @$().find('.nivoSlider').data('nivoslider').start()
