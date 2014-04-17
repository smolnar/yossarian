class Artist < ActiveRecord::Base
  validates :name, presence: true

  has_many :performances
  has_many :events, through: :performances
  has_many :headlined_events, -> { where(performances: { headliner: true }) }, through: :performances, source: :event

  def self.create_from_lastfm(data)
    artist     = find_or_initialize_by(name: data[:name])
    attributes = (data.keys & columns.map { |c| c.name.to_sym }) - [:created_at, :updated_at]

    artist.attributes = data.slice(*attributes)

    artist.save!

    artist
  end
end
