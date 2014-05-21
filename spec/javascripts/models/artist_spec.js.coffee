#= require spec_helper

describe 'Artist', ->
  it 'has name', ->
    artist = create 'artist', name: 'Bombay Bicycle Club'

    expect(artist.get('name')).to.eql('Bombay Bicycle Club')

  it 'has performances', ->
    artist = create 'artist', name: 'Arcade Fire'
    other  = create 'artist'

    3.times =>
      create 'performance', artist: artist

    expect(artist.get('performances.length')).to.eql(3)
    expect(other.get('performances.length')).to.eql(0)

  describe '@events', ->
    it 'provides events from performances', ->
      artist = create 'artist', name: 'Arcade Fire'
      events = [
        create('event', title: 'Coachella', artist: artist),
        create('event', title: 'Pohoda', artist: artist),
        create('event', title: 'Other')
      ]

      create 'performance', artist: artist, event: events[0]
      create 'performance', artist: artist, event: events[1]

      expect(artist.get('events.length')).to.eql(2)
      expect(artist.get('events').toArray()).to.eql(events[0..1])
      expect(artist.get('events.@each.title').toArray()).to.eql(['Coachella', 'Pohoda'])
