Yossarian.EventsView = Ember.View.extend
  didInsertElement: ->
    $(document).ready =>
      position = $('#navbar-controls').offset().top - 60

      $(window).scroll =>
        other = $(window).scrollTop()

        if position < other
          $('.navbar-fixed-top').addClass('navbar-inverse-affix')
        else
          $('.navbar-fixed-top').removeClass('navbar-inverse-affix')
