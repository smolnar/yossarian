class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :venue_name, :venue_city, :venue_country, :starts_at, :ends_at

  has_many :performances, embed: :ids, include: true

  def performances
    object.performances.sort_by(&:id)
  end
end
