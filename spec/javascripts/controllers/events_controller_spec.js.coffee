#= require spec_helper

describe 'EventsController', ->
  beforeEach ->
    @events     = []
    @controller = Yossarian.EventsController.create()

    3.times => @events.push create('event')

    @events.forEach (event) ->
      2.times -> event.get('artists').pushObject(create('artist'))

    @controller.set('content', @events)

  describe 'actions', ->
    describe '+play', ->
      it 'starts player with event artists', ->
        @controller.send('play', @events[0])

        player  = @controller.get('player')
        artists = @events[0].get('artists')

        expect(artists.get('length')).to.eql(2)

        expect(player.get('artists')).to.eql(@events[0].get('artists'))
        expect(player.get('playing')).to.eql(true)
