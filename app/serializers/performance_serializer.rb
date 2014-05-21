class PerformanceSerializer < ActiveModel::Serializer
  attributes :id

  has_one :artist, embed: :ids, include: true
  has_one :event,  embed: :ids
end
