class AddReminderToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :reminder, :string
  end
end
