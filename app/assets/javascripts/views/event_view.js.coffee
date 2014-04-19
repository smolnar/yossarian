Yossarian.EventView = Ember.View.extend
  tagName: 'li'

  mouseEnter: ->
    @$().find('.info').addClass('open')

  mouseLeave: ->
    @$().find('.info').removeClass('open')
