Rails.application.routes.draw do
  resources :posts, only: [:index, :show, :new, :create, :edit]
    get 'posts/:id/post_data', to: 'posts#post_data'
    get '/posts/:id/edit', to: 'posts#edit'
    patch '/posts/:id', to: 'posts#update'

end
