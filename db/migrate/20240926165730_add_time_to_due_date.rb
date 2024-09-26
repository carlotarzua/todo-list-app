class AddTimeToDueDate < ActiveRecord::Migration[7.2]
  def change
    remove_column :to_dos, :due_date, :date
    remove_column :to_dos, :due_time, :time
    add_column :to_dos, :due_datetime, :datetime
  end
end
