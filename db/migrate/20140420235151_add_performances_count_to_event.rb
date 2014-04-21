class AddPerformancesCountToEvent < ActiveRecord::Migration
  def change
    add_column :events, :performances_count, :integer, null: false, default: 0

    Event.find_each do |event|
      Event.update_counters event.id, performances_count: event.performances.count
    end
  end
end
