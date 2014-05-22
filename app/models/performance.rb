class Performance < ActiveRecord::Base
  belongs_to :artist
  belongs_to :event, counter_cache: true

  validates :headliner, inclusion: { in: [true, false] }

  after_save do
    event.reload.save!
  end
end
