#= require spec_helper

describe 'Artist', ->
  it 'has name', ->
    create 'artist', name: 'Bombay Bicycle Club'

    artist = Factory.find('artist').toArray()[0]

    expect(artist.get('name')).to.eql('Bombay Bicycle Club')
