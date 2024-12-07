class CreateBookshelves < ActiveRecord::Migration[7.2]
  def change
    create_table :bookshelves do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
