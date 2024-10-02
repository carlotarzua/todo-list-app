class CreateSharedLists < ActiveRecord::Migration[7.2]
  def change
    create_table :shared_lists do |t|
      t.string :name
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
