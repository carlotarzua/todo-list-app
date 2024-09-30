class AddArchivedToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :archived, :boolean, default: false, null: false
  end
end
