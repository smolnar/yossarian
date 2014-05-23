class Recording < ActiveRecord::Base
  include Recordings::Buildable

  belongs_to :track
  belongs_to :artist
end
