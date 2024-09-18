class AddCompletedToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :completed, :boolean
  end
end
