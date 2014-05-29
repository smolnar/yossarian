#= require spec_helper

describe 'Event', ->
  beforeEach ->
    @date  = new Date()
    @event = create 'event', title: 'Pohoda 2014', startsAt: @date

  it 'has title', ->
    expect(@event.get('title')).to.eql('Pohoda 2014')

  it 'has start date', ->
    expect(@event.get('startsAt')).to.eql(@date)

  it 'has performances', ->
    event = create 'event', title: 'Coachella'
    other = create 'event'

    3.times =>
      create 'performance', event: event

    expect(event.get('performances.length')).to.eql(3)
    expect(other.get('performances.length')).to.eql(0)

  describe '@artists', ->
    it 'provides artists from performances', ->
      event   = create 'event', title: 'Coachella'
      artists = [
        create('artist', name: 'Bombay Bicycle Club'),
        create('artist', name: 'Local Natives'),
        create('artist', name: 'Other')
      ]

      create 'performance', event: event, artist: artists[0]
      create 'performance', event: event, artist: artists[1]

      expect(event.get('artists.length')).to.eql(2)
      expect(event.get('artists.@each.name').toArray()).to.eql(['Bombay Bicycle Club', 'Local Natives'])

  describe '@shuffledArtists', ->
    it 'provides shuffled artists by two intervals', ->
      event   = create 'event'
      artists = []

      16.times -> artists.push(create('artist'))

      for artist in artists
        create 'performance', artist: artist, event: event

      expect(event.get('shuffledArtists')).not.to.eql(artists)

      for artist in artists[0..7]
        expect(event.get('shuffledArtists')[0..7]).to.include(artist)

      for artist in artists[8..15]
        expect(event.get('shuffledArtists')[8..15]).to.include(artist)
