class Event < ActiveRecord::Base
  include Searchable
  include Event::Buildable
  include Event::Geocodeable

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

  mount_uploader :poster, PosterUploader

  scope :in, lambda { |countries| where(events: { venue_country: countries }) }
  scope :with, lambda { |tags| where(tags.map { |name| '? = ANY(events.tags)' }.join(' OR '), *tags) }

  before_validation :set_poster

  before_save :set_tags

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

    self.tags = (self.tags.to_a + tags.to_a).uniq
  end
end
