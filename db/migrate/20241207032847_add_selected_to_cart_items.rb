class AddSelectedToCartItems < ActiveRecord::Migration[7.2]
  def change
    add_column :cart_items, :selected, :boolean, default: false
  end
end
