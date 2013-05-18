class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :subject
      t.string :email
      t.text :cards
      t.text :hand

      t.timestamps
    end
  end
end
