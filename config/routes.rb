Rails.application.routes.draw do
  resources :posts, only: [:index, :show, :new, :create, :update, :edit]
  get 'posts/:id/post_data', to: 'posts#post_data'
end
