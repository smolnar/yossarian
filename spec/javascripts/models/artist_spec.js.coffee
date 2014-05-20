#= require spec_helper

describe 'Artist', ->
  it 'has name', ->
    artist = create 'artist', name: 'Bombay Bicycle Club'

    expect(artist.get('name')).to.eql('Bombay Bicycle Club')
