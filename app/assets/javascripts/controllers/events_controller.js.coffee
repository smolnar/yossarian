#= require controllers/player_controller

Yossarian.EventsController = Ember.ArrayController.extend
  tags:      ['electronic', 'punk', 'house', 'folk', 'indie', 'hardcore', 'rock', 'country', 'dubstep', 'techno', 'reggae', 'hip-hop', 'alternative']
  countries: ['Slovakia', 'Germany', 'France', 'England', 'Hungary', 'Poland']

  query:             null
  selectedTags:      []
  selectedCountries: []
  currentPage:       0

  player: Yossarian.PlayerController.create()

  sortedTags: (->
    @get('tags').sort()
  ).property('tags')

  sortedCountries: (->
    @get('countries').sort()
  ).property('countries')

  contentDidChange: (->
    @get('player').set('event', @get('content').toArray()[0]) unless @get('player.event')
  ).observes('content.@each')

  propertiesForSearchDidChange: (->
    @set('currentPage', 0)

    @send('reload')
  ).observes('selectedCountries.@each', 'selectedTags.@each', 'query')

  actions:
    play: (event) ->
      @get('player').set('event', event)
      @get('player').play()

    selectTag: (tag) ->
      @get('selectedTags').pushObject(tag) if tag in @get('tags')

    selectCountry: (country) ->
      @get('selectedCountries').pushObject(country) if country in @get('countries')
