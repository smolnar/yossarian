class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster, :venue_name, :venue_city, :venue_country, :venue_latitude, :venue_longitude, :starts_at, :ends_at

  has_many :performances, embed: :ids, include: true

  def performances
    object.performances.sort_by(&:id)
  end
end
