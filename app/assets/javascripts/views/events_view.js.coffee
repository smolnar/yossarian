Yossarian.EventsView = Ember.View.extend
  didInsertElement: ->
    # TODO (smolnar) reload then viewport changes
    Ember.run.next @, ->
      for element in $('[data-affix]')
        $(element).affix offset: $(element).position()
