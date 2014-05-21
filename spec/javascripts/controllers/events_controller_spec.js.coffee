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
