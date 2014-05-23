module Recordings
  module Buildable
    extend ActiveSupport::Concern

    module ClassMethods
      def create_from_youtube(attributes)
        artist = Artist.find_or_create_by!(name: attributes[:artist])
        track  = Track.find_or_create_by!(name: attributes[:track])

        recording = Recording.find_or_create_by!(artist: artist, track: track)

        recording.update_attributes!(youtube_url: attributes[:url])

        recording
      end
    end
  end
end
