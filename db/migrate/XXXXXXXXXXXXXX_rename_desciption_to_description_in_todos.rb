class RenameDesciptionToDescriptionInTodos < ActiveRecord::Migration[6.0]
    def change
      rename_column :to_dos, :desciption, :description
    end
  end
  