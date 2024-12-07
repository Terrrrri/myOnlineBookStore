class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :book

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :book, presence: true # 确保关联的 Book 存在
end
