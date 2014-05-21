#= require controllers/player_controller

Yossarian.EventsController = Ember.ArrayController.extend
  genres:    ['electronic', 'punk', 'house', 'folk', 'indie', 'hardcore', 'rock', 'country', 'dubstep', 'techno', 'reggae', 'hip-hop', 'alternative']
  countries: ['Slovakia', 'Germany', 'France', 'England', 'Hungary', 'Poland']

  player: Yossarian.PlayerController.create()

  sortedGenres: (->
    @get('genres').sort()
  ).property('genres')

  sortedCountries: (->
    @get('countries').sort()
  ).property('countries')

  contentDidChange: (->
    @get('player').set('event', @get('content').toArray()[0]) unless @get('player.event')
  ).observes('content.@each')

  actions:
    play: (event) ->
      @get('player').set('event', event)
      @get('player').play()
