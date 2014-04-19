class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster

  has_many :recordings, embed: :ids, include: true
end
