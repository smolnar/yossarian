#= require spec_helper

describe 'EventsController', ->
  beforeEach ->
    @events     = []
    @controller = Yossarian.EventsController.create()

    3.times => @events.push Factory.create('event')

    @events.forEach (event) ->
      Ember.run => 2.times -> event.get('artists').pushObject(Factory.create('artist'))

    @controller.set('content', @events)

  describe 'actions', ->
    describe 'play', ->
      it 'starts player with event artists', ->
        Ember.run => @controller.send('play', @events[0])

        player  = @controller.get('player')
        artists = @events[0].get('artists')

        expect(artists.get('length')).to.eql(2)

        expect(player.get('artists')).to.eql(@events[0].get('artists'))
        expect(player.get('playing')).to.eql(true)
