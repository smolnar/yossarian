class AddDefaultValuesToArrays < ActiveRecord::Migration
  def up
    change_column :events,  :tags, :string, array: true, default: '{}'
    change_column :artists, :tags, :string, array: true, default: '{}'
  end

  def down
    change_column :events,  :tags, :string, array: true, default: nil
    change_column :artists, :tags, :string, array: true, default: nil
  end
end
