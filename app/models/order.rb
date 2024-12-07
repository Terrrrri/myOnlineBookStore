class Order < ApplicationRecord
  after_create :add_to_bookshelf
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true

  accepts_nested_attributes_for :order_items

  def book_details
    order_items.map do |item|
      {
        title: item.book.title,
        author: item.book.author,
        quantity: item.quantity,
        price: item.price
      }
    end
  end

  private
  def add_to_bookshelf
    order_items.each do |item|
      user.bookshelves.find_or_create_by(book: item.book)
    end
  end
end
