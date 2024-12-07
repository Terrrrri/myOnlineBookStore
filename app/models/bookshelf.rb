class Bookshelf < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book_id, uniqueness: { scope: :user_id, message: "already exists in your bookshelf" }
end
