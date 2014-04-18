class RecordingSerializer < ActiveModel::Serializer
  attributes :id, :youtube_url

  has_one :artist, embed: :ids, include: true
  has_one :track,  embed: :ids, include: true
end
