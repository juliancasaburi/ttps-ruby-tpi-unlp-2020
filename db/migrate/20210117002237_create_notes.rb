class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title, null:false
      t.text :content
      t.string :color, null:false
      t.belongs_to :user, null: false, foreign_key: {on_delete: :cascade}
      t.belongs_to :book, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
    add_index :notes, [:book_id, :title], unique: true
  end
end
