class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :lastfm_uuid
      t.string  :title,                  null: false
      t.string  :lastfm_url
      t.string  :website
      t.string  :venue_name
      t.string  :venue_latitude,         null: false
      t.string  :venue_longitude,        null: false
      t.string  :venue_city
      t.string  :venue_country
      t.string  :venue_street
      t.string  :venue_postalcode
      t.string  :venue_url
      t.date    :starts_at,              null: false
      t.date    :ends_at,                null: false
      t.string  :lastfm_image_small
      t.string  :lastfm_image_medium
      t.string  :lastfm_image_large
      t.string  :lastfm_image_extralarge
      t.string  :poster,                 null: false

      t.timestamps
    end

    add_index :events, :title
  end
end
