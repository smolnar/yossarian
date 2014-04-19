class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster, :venue_latitude, :venue_longitude, :starts_at, :ends_at

  has_many :artists, embed: :ids, include: true
end
