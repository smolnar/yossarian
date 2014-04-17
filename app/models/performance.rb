class Perfomance < ActiveRecord::Base
  belongs_to :artist
  belongs_to :event

  validates :headliner, presence: true

  before_save do
    self.headliner ||= false
  end
end
