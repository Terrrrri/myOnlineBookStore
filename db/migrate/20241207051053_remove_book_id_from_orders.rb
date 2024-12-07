class RemoveBookIdFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :book_id, :integer
  end
end
