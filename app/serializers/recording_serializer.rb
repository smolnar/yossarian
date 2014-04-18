class RecordingSerializer < ActiveModel::Serializer
  attributes :youtube_url

  has_one :artist, embed: :ids
  has_one :track,  embed: :ids
end
