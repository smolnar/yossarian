class Artist < ActiveRecord::Base
  validates :name,  presence: true

  has_many :performances
  has_many :events, through: :performances
  has_many :headlined_events, -> { where(performances: { headliner: true }) }, through: :performances, source: :event

  has_many :recordings
  has_many :tracks, through: :recordings

  mount_uploader :image, ImageUploader

  before_save :set_image

  def self.create_from_lastfm(data)
    artist     = find_or_initialize_by(name: data[:name])
    attributes = (data.keys & columns.map { |c| c.name.to_sym }) - [:created_at, :updated_at]

    artist.attributes = data.slice(*attributes)

    artist.save!

    data[:tracks].each do |name|
      track = Track.find_or_create_by!(name: name)

      Recording.find_or_create_by!(artist: artist, track: track)
    end

    artist
  end

  private

  def set_image
    image = DownloaderService.fetch([
      lastfm_image_mega,
      lastfm_image_extralarge
    ].compact)

    self.image = image ? image : nil
  end
end
