Spree::Core::Engine.routes.draw do
  resources :sharedlists
  resources :shared_products, only: [:create, :update, :destroy]
  # Add your extension routes here
end
