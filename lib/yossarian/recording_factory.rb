module Yossarian
  module RecordingFactory
    def self.update_from_youtube(id)
      YoutubeWorker.perform_async(id)
    end

    class YoutubeWorker
      include Sidekiq::Worker

      sidekiq_options queue: :youtube, backtrace: true

      def perform(id)
        recording = Recording.find(id)
        video     = Youtube::Music.of(artist: recording.artist.name, track: recording.track.name).first

        return unless video

        recording.update_attributes!(youtube_url: video.url)
      end
    end
  end
end
