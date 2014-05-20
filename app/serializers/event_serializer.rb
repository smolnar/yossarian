class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster, :venue_name, :venue_city, :venue_country, :venue_latitude, :venue_longitude, :starts_at, :ends_at

  has_many :artists, embed: :ids, include: true

  def artists
    object.performances.sort_by(&:id).map(&:artist)
  end
end
