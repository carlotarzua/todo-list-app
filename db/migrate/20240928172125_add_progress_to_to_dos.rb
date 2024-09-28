class AddProgressToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :progress, :integer, default: 0
  end
end
