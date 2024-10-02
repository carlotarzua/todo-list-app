class AddSharedListToToDos < ActiveRecord::Migration[7.2]
  def change
    add_reference :to_dos, :shared_list, foreign_key: true
  end
end
