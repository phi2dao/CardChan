class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :subject
      t.string :deck_type
      t.string :email
      t.text :cards
      t.text :hand

      t.timestamps
    end
    add_index :decks, :updated_at
  end
end
