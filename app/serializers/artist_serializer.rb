class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :recordings, embed: :ids, include: true

  def recordings
    object.recordings.first(5)
  end
end
