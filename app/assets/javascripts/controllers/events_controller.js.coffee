#= require controllers/player_controller

Yossarian.EventsController = Ember.ArrayController.extend
  player: Yossarian.PlayerController.create()

  actions: {
    play: (event) ->
      @get('player').set('artists', event.get('artists'))
      @get('player').play()
  }
