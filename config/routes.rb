Rails.application.routes.draw do
  # Cart and Cart Items routes
  resources :carts, only: [ :show ] do
    post :checkout, on: :member
  end
  resources :cart_items, only: [ :index, :create, :update, :destroy ] do
    patch :update_selected, on: :collection
  end

  # Orders routes
  resources :orders, only: [ :index, :show ]

  # Devise routes
  Rails.logger.debug "Devise routes being loaded"
  devise_for :users

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA-related routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Books routes
  resources :books do
    collection do
      get :search # 搜索书籍
    end
    member do
      post :buy_now # 立即购买
    end
  end

  # Root route
  root "books#index"

  # Bookshelves routes
  resources :bookshelves, only: [ :index, :create, :destroy ] do
    collection do
      get :search # 搜索书架
    end
  end

  # Orders routes with search functionality
  resources :orders, only: [ :index, :show ] do
    collection do
      get :search # 搜索订单
    end
  end

  # Custom logout route
  get "/logout", to: "sessions#destroy", as: :logout
end
