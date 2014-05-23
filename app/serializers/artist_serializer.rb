class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :image

  has_many :recordings, embed: :ids, include: true

  def recordings
    object.recordings.select { |recording| recording.youtube_url }.sort_by(&:id).first(10)
  end
end
