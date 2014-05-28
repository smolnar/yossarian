require 'spec_helper'

describe Lastfm::Artist do
  describe '.get' do
    it 'returns artist info' do
      urls = [
        'http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=test&format=json&artist=Bombay%20Bicycle%20Club',
        'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&api_key=test&format=json&artist=Bombay%20Bicycle%20Club&limit=10'
      ]

      data = [
        {
          artist: {
            id: 1,
            name: 'Bombay Bicycle Club'
          }
        },
        {
          toptracks: {
            track: [
              {
                name: 'Shuffle'
              }
            ]
          }
        }
      ]

      downloader = double(:downloader)
      factory    = double(:factory)
      parser     = double(:parser)

      Lastfm::Artist.downloader = downloader
      Lastfm::Artist.factory    = factory
      Lastfm::Artist.parser     = parser

      downloader.stub(:download).with(urls.first)  { data.first.to_json }
      downloader.stub(:download).with(urls.second) { data.second.to_json }

      parser.stub(:parse).with(data.first.to_json) { { id: 1, name: 'Bombay Bicycle Club' } }
      parser.stub(:parse_tracks).with(data.second.to_json) { [{ name: 'Shuffle' }] }

      expect(factory).to receive(:create_from_lastfm).with(id: 1, name: 'Bombay Bicycle Club', tracks: [{ name: 'Shuffle' }])

      Lastfm::Artist.get(artist: 'Bombay Bicycle Club')
    end
  end
end
