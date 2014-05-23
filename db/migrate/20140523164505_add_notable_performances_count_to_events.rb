class AddNotablePerformancesCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :notable_performances_count, :integer, null: false, default: 0
  end
end
