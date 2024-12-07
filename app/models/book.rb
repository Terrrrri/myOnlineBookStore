class Book < ApplicationRecord
  has_one_attached :cover_image
  has_one_attached :file_path

  validates :title, :author, :description, presence: true
  validates :cover_image, attached: true, content_type: [ "image/png", "image/jpeg" ]
  validates :file_path, attached: true, content_type: [ "application/pdf" ]
  # validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  has_many :bookshelves
  has_many :users, through: :bookshelves

  has_many :orders
  has_many :buyers, through: :orders, source: :user
end
