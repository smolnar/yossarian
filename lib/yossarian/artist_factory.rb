module Yossarian
  module ArtistFactory
    def self.create_from_lastfm(data)
      LastfmWorker.perform_async(data.to_json)
    end

    class LastfmWorker
      include Sidekiq::Worker

      sidekiq_options queue: :artists, backtrace: true

      def perform(data)
        attributes = JSON.parse(data, symbolize_names: true)

        Artist.create_from_lastfm(attributes)
      end
    end
  end
end
