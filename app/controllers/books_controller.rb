class BooksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource # 使用 Cancancan 自动加载和授权资源

  def index
    # Cancancan 自动加载可访问的书籍到 @books
    # @books = Book.all 已替换
    render :index
  end

  def show
    @book = Book.find(params[:id])
    @has_purchased = current_user.has_purchased?(@book)
    @in_bookshelf = current_user.bookshelves.exists?(book_id: @book.id)
    @in_cart = current_user.cart_items.exists?(book_id: @book.id)
  end

  def new
    # Cancancan 自动创建新的书籍实例到 @book
    Rails.logger.debug("Current user: #{current_user.inspect}")
  end

  def create
    # @book = Book.new(book_params.merge(price: 23))
    @book = Book.new(book_params)
    Rails.logger.debug("Price before save: #{@book.price.inspect} (Type: #{@book.price.class})")
    if @book.save

      redirect_to @book, notice: "Book was successfully created."
    else
      Rails.logger.debug("Book save failed: #{@book.errors.full_messages}")
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @query = params[:query]
    @books = Book.where("title ILIKE :query OR author ILIKE :query", query: "%#{@query}%")
    render :index # 使用现有的 index 页面模板展示搜索结果
  end

  def buy_now
    book = Book.find(params[:id])

    # 创建订单
    order = Order.create!(
      user: current_user,
      total_price: book.price,
      order_items_attributes: [
        {
          book_id: book.id,
          quantity: 1,
          price: book.price
        }
      ]
    )

    redirect_to order_path(order), notice: "You have successfully purchased #{book.title}!"
  end


  def edit
    # Cancancan 自动加载可编辑的书籍到 @book
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :price, :description, :cover_image, :file_path)
  end
end
