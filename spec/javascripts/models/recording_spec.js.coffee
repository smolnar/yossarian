#= require spec_helper

describe 'Recording', ->
  it 'has youtube url', ->
    recording = create 'recording', youtubeUrl: 'http://youtube.com/example'

    expect(recording.get('youtubeUrl')).to.eql('http://youtube.com/example')

  it 'belongs to artist and track', ->
    artist    = create 'artist', name: 'Bombay Bicycle Club'
    track     = create 'track', name: 'Shuffle'
    recording = create 'recording', artist: artist, track: track

    expect(recording.get('artist')).to.eql(artist)
    expect(recording.get('track')).to.eql(track)

    expect(artist.get('recordings').toArray()).to.eql([recording])
    expect(track.get('recordings').toArray()).to.eql([recording])
