class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.references :track,  index: true, null: false
      t.references :artist, index: true, null: false

      t.string :youtube_url

      t.timestamps
    end

    add_index :recordings, [:track_id, :artist_id], unique: true
  end
end
