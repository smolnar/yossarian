class AddIndexOnEventsVenueCountry < ActiveRecord::Migration
  def change
    add_index :events, :venue_country
  end
end
