class AddPriorityToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :priority, :integer
  end
end
