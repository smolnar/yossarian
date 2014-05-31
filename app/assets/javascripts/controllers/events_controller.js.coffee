#= require controllers/player_controller

Yossarian.EventsController = Ember.ArrayController.extend
  states:    { idle: 0, reloading: 1 }
  tags:      ['electronic', 'punk', 'house', 'folk', 'funk', 'minimal', 'jazz', 'rap', 'indie', 'hardcore', 'rock', 'country', 'dubstep', 'techno', 'reggae', 'hip-hop', 'alternative']
  countries: ['Finland', 'France', 'Italy', 'Poland', 'Ireland', 'Germany', 'Iceland', 'Belgium', 'Sweden', 'Netherlands', 'United Kingdom', 'Hungary', 'Denmark', 'Switzerland', 'Czech Republic', 'Spain', 'Portugal', 'Austria', 'Norway', 'Slovakia', 'Greece', 'Romania']

  query:             null
  queryTerm:         null
  selectedTags:      []
  selectedCountries: []
  currentPage:       0
  currentState:      1

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

  reloading: (->
    @get('currentState') == @get('states.reloading')
  ).property('currentState')

  contentDidChange: (->
    @get('player').set('event', @get('content').toArray()[0]) if @get('player.event') == null
  ).observes('content.@each')

  queryTermDidChange: (->
    queryTerm = @get('queryTerm')

    setTimeout (=>
      @set('query', queryTerm) if @get('queryTerm') == queryTerm
    ), 500
  ).observes('queryTerm')

  propertiesForSearchDidChange: (->
    return @notifyPropertyChange('currentPage') if @get('currentPage') == 0

    @set('currentPage', 0)
  ).observes('selectedCountries.@each', 'selectedTags.@each', 'query.length')

  currentPageDidChange: (->
    @set('content', [])
    @set('currentState', @get('states.reloading'))

    @send('reload', => @set('currentState', @get('states.idle')))
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
