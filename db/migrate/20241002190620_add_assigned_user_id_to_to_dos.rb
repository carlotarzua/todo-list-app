class AddAssignedUserIdToToDos < ActiveRecord::Migration[7.2]
  def change
    add_column :to_dos, :assigned_user_id, :integer
  end
end
