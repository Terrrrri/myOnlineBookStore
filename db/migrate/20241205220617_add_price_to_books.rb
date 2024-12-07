class AddPriceToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :price, :decimal
  end
end
