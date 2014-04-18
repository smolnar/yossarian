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
        video  = Youtube::Music.of(artist: params[:artist], track: params[:track]).first

        return unless video

        Recording.create_from_youtube(params.merge(url: video.url))
      end
    end
  end
end
