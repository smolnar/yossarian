#= require spec_helper

describe 'EventsController', ->
  beforeEach ->
    @events     = []
    @artists    = []
    @controller = Yossarian.EventsController.create()

    3.times => @events.push create('event')
    3.times =>
      artist = create 'artist'

      @artists.push(artist)

      create 'recording', artist: artist

    for event in @events[0..1]
      for artist in @artists
        create 'performance', event: event, artist: artist

  describe 'observers', ->
    describe '+contentDidChange', ->
      beforeEach ->
        @controller.set('player.event', null)
        @controller.set('content', @events)

      it 'sets default event for player', ->
        expect(@controller.get('player.event')).to.eql(@events[0])

      context 'when player has already event set', ->
        it 'ommit setting the default event', ->
          @controller.set('content', @events[1..2])

          expect(@controller.get('player.event')).to.eql(@events[0])

    describe '+propertiesForSearchDidChange', ->
      beforeEach ->
        router  = mock(send: ->)
        @router = router.mock

        @controller.set('target', router.object)
        @controller.set('currentPage', 1)
        @controller.set('countries', ['Slovakia'])
        @controller.set('tags', ['rock'])

        @router.expects('send').withExactArgs('reload').once()

      afterEach ->
        expect(@controller.get('currentPage')).to.eql(0)

      context 'when selected counties changes', ->
        it 'reloads data and changes current page', ->
          @controller.send('toggleSelectionOfCountry', 'Slovakia')

      context 'when selected tags changes', ->
        it 'reloads data and changes current page', ->
          @controller.send('toggleSelectionOfTag', 'rock')

      context 'when query changes', ->
        it 'reloads data and changes current page', ->
          @controller.set('query', 'a')

    describe '+currentPageDidChange', ->
      beforeEach ->
        router  = mock(send: ->)
        @router = router.mock

        @controller.set('target', router.object)
        @controller.set('currentPage', 1)

        @router.expects('send').withExactArgs('reload').once()

      context 'when page changes', ->
        it 'reloads data and sets content to empty array', ->
          events = []

          3.times ->
            events.push(create('event'))

          @controller.set('content', events)
          @controller.set('currentPage', 2)

          expect(@controller.get('content.length')).to.eql(0)

  describe 'actions', ->
    describe '+play', ->
      it 'starts player with event artists', ->
        @controller.send('play', @events[0])

        player  = @controller.get('player')
        artists = @events[0].get('artists').toArray()

        expect(artists.length).to.eql(3)
        expect(player.get('artists')).to.eql(@events[0].get('artists'))

      context 'when event has no artist', ->
        it 'does not start player', ->
          event = @events[2]

          @controller.send('play', event)

          player  = @controller.get('player')
          artists = event.get('artists')

          expect(artists.get('length')).to.eql(0)
          expect(player.get('artists')).to.eql(event.get('artists'))

    describe '+toggleSelectionOfTag', ->
      it 'selects multiple tags', ->
        @controller.set('selectedTags', [])
        @controller.set('tags', ['indie', 'rock', 'electronic'])

        @controller.send('toggleSelectionOfTag', 'indie')
        @controller.send('toggleSelectionOfTag', 'rock')

        expect(@controller.get('selectedTags.length')).to.eql(2)
        expect(@controller.get('selectedTags')).to.include('indie')
        expect(@controller.get('selectedTags')).to.include('rock')

      context 'when tag is in the list of tags', ->
        it 'selects a tag', ->
          @controller.set('tags', ['indie', 'rock'])

          @controller.send('toggleSelectionOfTag', 'indie')

          expect(@controller.get('selectedTags')).to.include('indie')

      context 'when tag is already selected', ->
        it 'deselects a tag', ->
          @controller.set('tags', ['indie', 'rock'])

          @controller.send('toggleSelectionOfTag', 'indie')

          Ember.run.later =>
            @controller.send('toggleSelectionOfTag', 'indie')

          expect(@controller.get('selectedTags')).not.to.include('indie')

      context 'when tag is not in the list of tags', ->
        it 'does not select a tag', ->
          @controller.set('tags', ['indie', 'rock'])

          @controller.send('toggleSelectionOfTag', 'pop')

          expect(@controller.get('selectedTags')).not.to.include('pop')

    describe '+toggleSelectionOfCountry', ->
      beforeEach ->
        @controller.set('selectedCountries', [])

      it 'selects multiple countries', ->
        @controller.set('countries', ['Slovakia', 'Norway', 'Austria'])

        @controller.send('toggleSelectionOfCountry', 'Slovakia')
        @controller.send('toggleSelectionOfCountry', 'Norway')

        expect(@controller.get('selectedCountries.length')).to.eql(2)
        expect(@controller.get('selectedCountries')).to.include('Slovakia')
        expect(@controller.get('selectedCountries')).to.include('Norway')

      context 'when country is in the list of countries', ->
        it 'selects a country', ->
          @controller.set('countries', ['Slovakia', 'Norway'])

          @controller.send('toggleSelectionOfCountry', 'Slovakia')

          expect(@controller.get('selectedCountries')).to.include('Slovakia')

      context 'when country is already selected', ->
        it 'deselects the country', ->
          @controller.set('countries', ['Slovakia', 'Norway'])

          @controller.send('toggleSelectionOfCountry', 'Slovakia')
          @controller.send('toggleSelectionOfCountry', 'Slovakia')

          expect(@controller.get('selectedCountries')).not.to.include('Slovakia')

      context 'when country is not in the list of countries', ->
        it 'does not select a country', ->
          @controller.set('countries', ['Slovakia', 'Norway'])

          @controller.send('toggleSelectionOfCountry', 'Hungary')

          expect(@controller.get('selectedCountries')).not.to.include('Hungary')
