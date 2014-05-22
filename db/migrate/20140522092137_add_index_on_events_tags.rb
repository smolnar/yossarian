class AddIndexOnEventsTags < ActiveRecord::Migration
  def change
    add_index :events, :tags, using: :gin
  end
end
