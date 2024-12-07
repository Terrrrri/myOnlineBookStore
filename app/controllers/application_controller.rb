class ApplicationController < ActionController::Base
  before_action :initialize_cart
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  private

  def initialize_cart
    if current_user
      current_user.create_cart unless current_user.cart
    end
  end
end
