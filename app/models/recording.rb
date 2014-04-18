class Recording < ActiveRecord::Base
  belongs_to :track
  belongs_to :artist

  def self.create_from_youtube(attributes)
    artist = Artist.find_or_create_by!(name: attributes[:artist])
    track  = Track.find_or_create_by!(name: attributes[:track])

    recording = Recording.find_or_create_by!(artist: artist, track: track)

    recording.update_attributes!(youtube_url: attributes[:url])

    recording
  end
end
