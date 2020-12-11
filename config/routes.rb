Rails.application.routes.draw do
  resources :orders, except: [:update]
  root 'warehouse#index'
  get 'warehouse/index'
  resources :wares
  devise_for :admins
  devise_scope :admin do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  post 'process_ware', to: 'wares#process_ware'
  get '/success', to: 'orders#success', as: 'success'
  get '/cancel', to: 'orders#cancel', as: 'cancel'
end
