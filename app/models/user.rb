class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :bookshelves
  has_many :books, through: :bookshelves

  has_many :orders
  has_many :order_items, through: :orders
  has_many :purchased_books, through: :order_items, source: :book

  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :books_in_cart, through: :cart_items, source: :book

  after_commit :create_cart, on: :create

  ROLES = %w[user admin]

  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  def has_purchased?(book)
    purchased_books.include?(book)
  end

  def create_cart
    Rails.logger.debug "Creating cart for user: #{self.id}"
    Cart.create(user: self)
  end
end
