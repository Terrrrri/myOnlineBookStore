class BookshelvesController < ApplicationController
  before_action :authenticate_user!

  # 显示当前用户的书架
  def index
    @bookshelves = current_user.bookshelves.includes(:book)
  end

  def search
    @query = params[:query]
    @bookshelves = current_user.bookshelves.joins(:book).where("books.title ILIKE :query OR books.author ILIKE :query", query: "%#{@query}%")
    render :index # 使用现有的 index 页面模板展示搜索结果
  end

  # 将书籍添加到书架
  def create
    Rails.logger.debug("BookshelvesController#create called with book_id: #{params[:book_id]}")

    book = Book.find(params[:book_id])
    bookshelf = current_user.bookshelves.find_or_initialize_by(book: book)

    Rails.logger.debug("Current user: #{current_user.inspect}")
    if bookshelf.save
      flash[:notice] = "Book successfully added to your bookshelf."
    else
      flash[:alert] = "Failed to add book to your bookshelf. #{bookshelf.errors.full_messages.join(', ')}"
    end
    redirect_to book_path(book)
  end

  # 从书架中移除书籍
  def destroy
    bookshelf = current_user.bookshelves.find(params[:id])
    if bookshelf.destroy
      flash[:notice] = "Book removed from your bookshelf."
    else
      flash[:alert] = "Failed to remove the book. #{bookshelf.errors.full_messages.join(', ')}"
    end
    redirect_to bookshelves_path
  end
end
