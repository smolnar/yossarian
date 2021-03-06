class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name,                   null: false
      t.string :image
      t.string :musicbrainz_uuid
      t.string :lastfm_url
      t.string :lastfm_image_small
      t.string :lastfm_image_medium
      t.string :lastfm_image_large
      t.string :lastfm_image_extralarge
      t.string :lastfm_image_mega
      t.string :tags,                   array: true
      t.string :lastfm_summary

      t.timestamps
    end

    add_index :artists, :name, unique: true
  end
end
