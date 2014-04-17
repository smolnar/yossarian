class Track < ActiveRecord::Base
  validates :name, presence: true

  has_many :recordings
  has_many :tracks, through: :recordings
end
