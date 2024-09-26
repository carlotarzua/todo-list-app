class AddEmailToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :email, :string
  end
end
