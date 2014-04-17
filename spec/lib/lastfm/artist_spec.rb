require 'spec_helper'

describe Lastfm::Artist do
  describe '.get' do
    it 'returns artist info' do
      urls = [
        'http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=test&format=json&artist=Bombay Bicycle Club',
        'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&api_key=test&format=json&artist=Bombay Bicycle Club'
      ]

      downloader = double(:downloader)
      factory    = double(:factory)

      Lastfm::Artist.downloader = downloader
      Lastfm::Artist.factory    = factory

      downloader.stub(:download).with(urls.first) do
        {
          artist: {
            id: 1,
            name: 'Bombay Bicycle Club'
          }
        }.to_json
      end

      downloader.stub(:download).with(urls.second) do
        {
          toptracks: {
            track: [
              {
                name: 'Shuffle'
              }
            ]
          }
        }.to_json
      end

      expect(factory).to receive(:create_from_lastfm).with(id: 1, name: 'Bombay Bicycle Club', tracks: [{ name: 'Shuffle' }])

      Lastfm::Artist.get(artist: 'Bombay Bicycle Club')
    end
  end
end
