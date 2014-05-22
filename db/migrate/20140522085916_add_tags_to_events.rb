class AddTagsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :tags, :string, array: true
  end
end
