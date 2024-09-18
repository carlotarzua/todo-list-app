class ChangePriorityInToDos < ActiveRecord::Migration[7.2]
  def change
    change_column :to_dos, :priority, :string
  end
end
