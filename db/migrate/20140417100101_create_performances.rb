class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.references :artist, index: true
      t.references :event,  index: true

      t.boolean :headliner, null: false

      t.timestamps
    end

    add_index :performances, [:event_id, :headliner]
    add_index :performances, [:artist_id, :event_id, :headliner], unique: true
  end
end
