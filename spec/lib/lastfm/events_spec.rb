require 'spec_helper'

describe Lastfm::Events do
  describe '.get' do
    it 'returns events for location' do
      urls = [
        'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&api_key=test&format=json&page=1&location=europe',
        'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&api_key=test&format=json&page=2&location=europe'
      ]

      data = [
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
        },
        {
          events: {
            event: [
            ],

            :@attr => {
              page: 2,
              totalPages: 2
            }
          }
        }
      ]

      downloader = double(:downloader)
      factory    = double(:factory)
      parser     = double(:parser)

      Lastfm::Events.downloader = downloader
      Lastfm::Events.factory    = factory
      Lastfm::Events.parser     = parser

      downloader.stub(:download).with(urls.first)  { data.first.to_json }
      downloader.stub(:download).with(urls.second) { data.second.to_json }

      parser.stub(:parse).with(data.first.to_json) do
        [{ page: 1, total_pages: 2}, [{ id: 1, title: 'Coachella' }]]
      end

      parser.stub(:parse).with(data.second.to_json) do
        [{ page: 2, total_pages: 2}, []]
      end

      expect(factory).to receive(:create_from_lastfm).with(id: 1, title: 'Coachella')

      Lastfm::Events.get(location: :europe)
    end
  end
end
