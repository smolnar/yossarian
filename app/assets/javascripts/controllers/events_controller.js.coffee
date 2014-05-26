#= require controllers/player_controller

Yossarian.EventsController = Ember.ArrayController.extend
  tags:      ['electronic', 'punk', 'house', 'folk', 'indie', 'hardcore', 'rock', 'country', 'dubstep', 'techno', 'reggae', 'hip-hop', 'alternative']
  countries: ['Slovakia', 'Germany', 'France', 'England', 'Hungary', 'Poland']

  query:             null
  queryTerm:         null
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

  hasNextPage: (->
    if @get('content.length') > 0 then true else false
  ).property('content.length')

  hasPreviousPage: (->
    if @get('currentPage') > 0 then true else false
  ).property('currentPage')

  contentDidChange: (->
    @get('player').set('event', @get('content').toArray()[0]) unless @get('player.event')
  ).observes('content.@each')

  queryTermDidChange: (->
    queryTerm = @get('queryTerm')

    setTimeout (=>
      @set('query', queryTerm) if @get('queryTerm') == queryTerm
    ), 300
  ).observes('queryTerm')

  propertiesForSearchDidChange: (->
    @set('currentPage', 0)
  ).observes('selectedCountries.@each', 'selectedTags.@each', 'query.length')

  currentPageDidChange: (->
    @send('reload')
  ).observes('currentPage')

  actions:
    next: ->
      @set('currentPage', @get('currentPage') + 1) if @get('hasNextPage')

    previous: ->
      @set('currentPage', @get('currentPage') - 1) if @get('hasPreviousPage')

    play: (event) ->
      @get('player').set('event', event)
      @get('player').play()

    toggleSelectionOf: (value, options) ->
      all       = options.in
      selected  = options.for

      if value in @get(all) && value not in @get(selected)
        @get(selected).pushObject(value)
      else
        @get(selected).removeObject(value)

    toggleSelectionOfTag: (tag) -> @send('toggleSelectionOf', tag, in: 'tags', for: 'selectedTags')
    toggleSelectionOfCountry: (country) -> @send('toggleSelectionOf', country, in: 'countries', for: 'selectedCountries')
