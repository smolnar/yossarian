class Event < ActiveRecord::Base
  include Events::Searchable
  include Events::Buildable
  include Events::Geocodeable

  validates :title,           presence: true
  validates :venue_longitude, presence: true
  validates :venue_latitude,  presence: true
  validates :starts_at,       presence: true
  validates :poster,          presence: true

  has_many :performances, -> { order(id: :asc) }
  has_many :artists, through: :performances
  has_many :headliners, -> { where(performances: { headliner: true }) }, through: :performances, source: :artist

  has_many :recordings, -> { where.not(youtube_url: nil) }, through: :artists
  has_many :tracks, through: :recordings

  scope :in, lambda { |countries| where(events: { venue_country: countries }) }
  scope :with, lambda { |tags| where(tags.map { |name| '? = ANY(events.tags)' }.join(' OR '), *tags) }

  before_validation :set_poster
  before_save :set_tags
  before_save :set_notable_performances_count

  mount_uploader :poster, PosterUploader

  private

  def set_poster
    return if poster.file.try(:exists?)

    self.poster = DownloaderService.fetch([lastfm_image_extralarge, lastfm_image_medium, lastfm_image_small].compact)
  end

  def set_tags
    tags = artists.map do |artist|
      next unless artist.tags.present?

      artist.tags.first
    end

    self.tags = (self.tags.to_a + tags.to_a).compact.uniq
  end

  def set_notable_performances_count
    self.notable_performances_count = performances.joins(:artist, artist: [:recordings]).where.not(artists: { image: nil }, recordings: { youtube_url: nil }).count
  end
end
