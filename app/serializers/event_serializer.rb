class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster, :venue_latitude, :venue_longitude

  has_many :artists, embed: :ids, include: true
end
