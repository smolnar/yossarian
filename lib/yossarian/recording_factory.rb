module Yossarian
  module RecordingFactory
    def self.create_from_youtube(params)
      YoutubeWorker.perform_async(params.to_json)
    end

    class YoutubeWorker
      include Sidekiq::Worker

      sidekiq_options queue: :youtube, backtrace: true

      def perform(params)
        params = JSON.parse(params, symbolize_names: true)
        url    = Youtube::Music.of(artist: params[:artist], track: params[:track])

        Recording.create_from_youtube(params.merge(url: url))
      end
    end
  end
end
