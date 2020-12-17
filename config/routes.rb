Rails.application.routes.draw do
  resources :orders, except: [:update, :destroy, :new, :create]
  root 'warehouse#index'
  get 'warehouse/index'
  resources :wares
  devise_for :admins
  devise_scope :admin do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  get '/start', to: 'orders#start', as: 'start_order'
  post '/continue', to: 'orders#continue', as: 'continue_order'
  get '/success', to: 'orders#success', as: 'success'
  get '/cancel', to: 'orders#cancel', as: 'cancel'
end
