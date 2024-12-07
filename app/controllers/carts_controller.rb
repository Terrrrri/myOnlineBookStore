class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def create
    @cart_item = @cart.cart_items.find_or_initialize_by(book_id: params[:book_id])
    @cart_item.quantity ||= 0
    @cart_item.quantity += 1

    if @cart_item.save
      redirect_to cart_path(@cart), notice: "Book added to cart."
    else
      redirect_to books_path, alert: "Unable to add book to cart."
    end
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])

    if @cart_item.update(cart_item_params)
      redirect_to cart_path(@cart), notice: "Cart updated."
    else
      redirect_to cart_path(@cart), alert: "Unable to update cart."
    end
  end

  def show
    @cart_items = @cart.cart_items.includes(:book)
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path(@cart), notice: "Book removed from cart."
  end

  def checkout
    if @cart.cart_items.any?
      # 创建订单
      order = Order.create!(
        user: current_user,
        total_price: @cart.total_price,
        order_items_attributes: @cart.cart_items.map do |item|
          {
            book_id: item.book_id,
            quantity: item.quantity,
            price: item.book.price
          }
        end
      )

      # 清空购物车
      @cart.cart_items.destroy_all
      redirect_to order_path(order), notice: "Checkout successful!"
    else
      redirect_to cart_path(@cart), alert: "Your cart is empty."
    end
  end


  private

  def set_cart
    # 确保每个用户只有一个购物车，如果没有就创建
    @cart = current_user.cart || current_user.create_cart
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
