class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :image

  has_many :recordings, embed: :ids, include: true

  def recordings
    # TODO
    object.recordings.first(5)
  end
end
