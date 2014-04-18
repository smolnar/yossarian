class EventSerializer < ActiveModel::Serializer
  attributes :title

  has_many :recordings, embed: :ids, include: true
end
