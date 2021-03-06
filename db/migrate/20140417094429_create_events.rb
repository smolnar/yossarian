class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   :lastfm_uuid
      t.string   :title,                  null: false
      t.text     :lastfm_description
      t.string   :lastfm_url,             limit: 1024
      t.string   :website,                limit: 1024
      t.string   :venue_name
      t.string   :venue_latitude,         null: false
      t.string   :venue_longitude,        null: false
      t.string   :venue_city
      t.string   :venue_country
      t.string   :venue_street
      t.string   :venue_postalcode
      t.string   :venue_url
      t.datetime :starts_at,              null: false
      t.datetime :ends_at
      t.string   :lastfm_image_small
      t.string   :lastfm_image_medium
      t.string   :lastfm_image_large
      t.string   :lastfm_image_extralarge
      t.string   :poster,                 null: false

      t.timestamps
    end

    add_index :events, :title
  end
end
