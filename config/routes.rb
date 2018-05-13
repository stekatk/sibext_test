Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :categories, only: [:index, :create] do
    resources :products, only: [:index, :create]
  end

  delete 'products/:id(.:format)', to: 'products#destroy'
end
