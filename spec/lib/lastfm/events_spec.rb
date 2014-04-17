require 'spec_helper'

describe Lastfm::Events do
  describe '.get' do
    it 'returns events for location' do
      urls = [
        'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&api_key=test&format=json&page=1&location=europe',
        'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&api_key=test&format=json&page=2&location=europe'
      ]

      downloader = double(:downloader)
      factory    = double(:factory)

      Lastfm::Events.downloader = downloader
      Lastfm::Events.factory    = factory

      downloader.stub(:download).with(urls.first) do
        {
          events: {
            event: [
              {
                id: 1,
                title: 'Coachella'
              }
            ],

            :@attr => {
              page: 1,
              totalPages: 2
            }
          }
        }.to_json
      end

      downloader.stub(:download).with(urls.second) do
        {
          events: {
            event: [
            ],

            :@attr => {
              page: 2,
              totalPages: 2
            }
          }
        }.to_json
      end

      expect(factory).to receive(:create_from_lastfm).with(id: 1, title: 'Coachella')

      Lastfm::Events.get(location: :europe)
    end
  end
end
