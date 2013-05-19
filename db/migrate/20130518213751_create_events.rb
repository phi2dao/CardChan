class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :input
      t.string :action
      t.string :email
      t.string :output
      t.integer :deck_id

      t.timestamps
    end
    add_index :events, [:deck_id, :created_at]
  end
end
