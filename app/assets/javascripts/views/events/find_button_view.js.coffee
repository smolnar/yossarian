Yossarian.EventFindButtonView = Ember.View.extend
  click: ->
    $('html, body').animate(scrollTop: $('#events').offset().top - 120, 500)
