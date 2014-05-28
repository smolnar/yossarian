class Recording < ActiveRecord::Base
  include Recordings::Buildable

  belongs_to :track
  belongs_to :artist

  after_save :update_artists_events!

  private

  def update_artists_events!
    artist.events.each(&:save!)
  end
end
