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

  post 'process_ware/:ware_id', to: 'wares#process_ware'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
