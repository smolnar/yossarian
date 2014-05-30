class Recording < ActiveRecord::Base
  belongs_to :track
  belongs_to :artist

  after_save :update_artists_events!
  after_destroy :update_artists_events!

  private

  def update_artists_events!
    artist.events.reload.each(&:save!)
  end
end
