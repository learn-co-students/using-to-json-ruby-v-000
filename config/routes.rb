Rails.application.routes.draw do
  resources :posts
  get 'posts/:id/post_data', to: 'posts#post_data'
end
