class Performance < ActiveRecord::Base
  belongs_to :artist, counter_cache: true
  belongs_to :event

  validates :headliner, inclusion: { in: [true, false] }
end
