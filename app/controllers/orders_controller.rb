class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
    @order = current_user.orders.find(params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @cart = current_user.cart

    if @cart.cart_items.any?
      @order = Order.create!(
        user: current_user,
        total_price: @cart.total_price,
        order_items_attributes: @cart.cart_items.map do |item|
          {
            book_id: item.book_id,
            quantity: item.quantity,
            price: item.book.price
          }
        end # 修复语法错误：正确地结束 `do` 块
      )
      @cart.cart_items.destroy_all
      redirect_to order_path(@order), notice: "Order created successfully!"
    else
      redirect_to cart_path(@cart), alert: "Your cart is empty!"
    end
  end

  def search
    @query = params[:query]
    @orders = current_user.orders.joins(:order_items).where("order_items.book_id IN (?)",
                Book.where("title ILIKE :query OR author ILIKE :query", query: "%#{@query}%").pluck(:id))
    render :index # 使用现有的 index 页面模板展示搜索结果
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :book_id, :total_price, :status)
    end
end
