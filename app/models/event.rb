class Event < ActiveRecord::Base
  validates :title,           presence: true
  validates :venue_longitude, presence: true
  validates :venue_latitude,  presence: true
  validates :starts_at,       presence: true
  validates :poster,          presence: true

  has_many :performances
  has_many :artists, through: :performances
  has_many :headliners, -> { where(performances: { headliner: true }) }, through: :performances, source: :artist

  has_many :recordings, -> { where.not(youtube_url: nil) }, through: :artists
  has_many :tracks, through: :recordings

  mount_uploader :poster, PosterUploader

  before_validation :set_poster

  after_validation :reverse_geocode

  reverse_geocoded_by :venue_latitude, :venue_longitude do |record, results|
    if data = results.first
      record.venue_city    = data.city unless record.venue_city.present?
      record.venue_country = data.country unless record.venue_country.present?
    end
  end

  def self.create_from_lastfm(data)
    data  = data.symbolize_keys
    event = find_by(lastfm_uuid: data[:lastfm_uuid]) || find_or_initialize_by(title: data[:title])

    attributes = (data.keys & columns.map { |c| c.name.to_sym }) - [:created_at, :updated_at]

    event.attributes = data.slice(*attributes)

    event.save!

    data[:artists].each do |name|
      artist = Artist.find_or_create_by!(name: name)

      Performance.find_or_create_by!(artist: artist, event: event, headliner: data[:headliner] == name)
    end

    event
  end

  private

  def set_poster
    return if poster.file.try(:exists?)

    self.poster = DownloaderService.fetch([
      lastfm_image_extralarge,
      lastfm_image_medium,
      lastfm_image_small
    ].compact)
  end
end
