class AddTimeTrackingToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :start_time, :datetime
    add_column :to_dos, :end_time, :datetime
    add_column :to_dos, :total_time, :integer, default: 0
  end
end
