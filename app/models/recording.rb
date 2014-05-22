class Recording < ActiveRecord::Base
  include Recording::Buildable

  belongs_to :track
  belongs_to :artist
end
