class Performance < ActiveRecord::Base
  belongs_to :artist
  belongs_to :event

  validates :headliner, inclusion: { in: [true, false] }
end
