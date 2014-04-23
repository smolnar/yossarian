class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :image

  has_many :recordings, embed: :ids, include: true

  def recordings
    object.recordings.sort_by(&:id).first(10)
  end
end
