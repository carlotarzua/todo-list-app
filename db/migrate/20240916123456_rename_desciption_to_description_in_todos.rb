class RenameDesciptionToDescriptionInTodos < ActiveRecord::Migration[6.0]
  def change
    if column_exists?(:to_dos, :desciption)
      rename_column :to_dos, :desciption, :description
    end
  end
end
