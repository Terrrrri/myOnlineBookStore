class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def total_price
    cart_items.includes(:book).sum { |item| item.book.price * item.quantity }
  end
end
