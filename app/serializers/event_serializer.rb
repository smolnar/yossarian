class EventSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :recordings, embed: :ids, include: true
end
