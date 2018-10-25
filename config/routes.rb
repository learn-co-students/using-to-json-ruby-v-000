Rails.application.routes.draw do
  resources :posts, only: [:index, :show, :new, :create, :edit]

  get 'posts/:id/show', to: 'posts#show'
end
