class AddIndexOnEventSearchAttributes < ActiveRecord::Migration
  def change
    add_index :events, :venue_country
    add_index :artists, :tags, using: :gin
  end
end
