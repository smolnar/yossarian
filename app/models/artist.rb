class Artist < ActiveRecord::Base
  validates :name, presence: true

  has_many :performances
  has_many :events, through: :performances
  has_many :headlined_events, -> { where(headliner: true) }, through: :performances, class_name: :Event
end
