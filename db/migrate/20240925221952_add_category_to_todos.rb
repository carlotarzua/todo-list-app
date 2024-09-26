class AddCategoryToTodos < ActiveRecord::Migration[7.2]
  def change
    add_reference :to_dos, :category, null: true, foreign_key: true
  end
end
