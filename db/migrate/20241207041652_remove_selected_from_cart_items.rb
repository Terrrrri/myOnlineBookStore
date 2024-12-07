class RemoveSelectedFromCartItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :cart_items, :selected, :boolean
  end
end
