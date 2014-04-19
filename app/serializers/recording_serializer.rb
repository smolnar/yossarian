class RecordingSerializer < ActiveModel::Serializer
  attributes :id, :youtube_url

  has_one :artist, embed: :ids
  has_one :track,  embed: :ids, include: true
end
