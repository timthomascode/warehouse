Rails.application.routes.draw do
  root 'warehouse#index'
  get 'warehouse/index'
  resources :wares
  devise_for :admins
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
