class Artist < ActiveRecord::Base
  include Artist::Buildable

  validates :name,  presence: true

  has_many :performances
  has_many :events, through: :performances
  has_many :headlined_events, -> { where(performances: { headliner: true }) }, through: :performances, source: :event

  has_many :recordings
  has_many :tracks, through: :recordings

  before_validation :set_image
  after_save :update_events

  mount_uploader :image, ImageUploader

  private

  def set_image
    return if image.file.try(:exists?)

    self.image = DownloaderService.fetch([
      lastfm_image_mega,
      lastfm_image_extralarge
    ].compact)
  end

  def update_events
    events.reload.each(&:save!)
  end
end
