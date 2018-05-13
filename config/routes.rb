Rails.application.routes.draw do
  resources :categories, only: [:index, :create] do
    resources :products, only: [:index, :create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
