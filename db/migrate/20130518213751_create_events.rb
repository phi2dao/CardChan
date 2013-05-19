class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :card
      t.integer :quantity
      t.string :action
      t.string :note
      t.integer :deck_id

      t.timestamps
    end
    add_index :events, [:deck_id, :created_at]
  end
end
