class Event < ActiveRecord::Base
  validates :title,           presence: true
  validates :venue_longitude, presence: true
  validates :venue_latitude,  presence: true
  validates :starts_at,       presence: true
  validates :ends_at,         presence: true

  has_many :performances
  has_many :artists, through: :performaces
  has_many :headliners, -> { where(headliner: true) }, through: :performaces, class_name: :Artist
end
