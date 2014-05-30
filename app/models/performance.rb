class Performance < ActiveRecord::Base
  belongs_to :artist
  belongs_to :event, counter_cache: true

  validates :headliner, inclusion: { in: [true, false] }

  after_save :update_event!
  after_destroy :update_event!

  def update_event!
    event.reload.save!
  end
end
