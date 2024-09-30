class AddOwnerAndUserToTeams < ActiveRecord::Migration[7.2]
  def change
    # add_reference :teams, :owner, foreign_key: { to_table: :users }
    add_reference :teams, :user, null: false, foreign_key: true
  end
end
