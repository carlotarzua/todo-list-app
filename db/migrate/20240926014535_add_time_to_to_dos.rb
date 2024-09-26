class AddTimeToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :due_time, :time
  end
end
