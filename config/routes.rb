Rails.application.routes.draw do
  # get 'users/sign_in_process'

  # get 'users/sign_up_process'

  # get 'users/sign_in'

  # get 'users/sign_up'

  # get 'users/follow_list'

  # get 'users/follower_list'
  

  # get 'users/edit'

  # get 'users/show'

  # get 'posts/new'

  # get 'users/top'
  
  
  # get '/', to:'users#top'
  get '/top', to:'users#top', as: :top
  
  root 'users#top'
  
  
  # 通常の指定
  # get 'posts/new', to:'posts#new', as: :new_post
  # resourcesメソッドを使った指定
  resources :posts do
    member do
      #いいね
      get 'like', to: 'posts#like', as: :like
      #コメント投稿機能
      get 'comment', to: 'posts#comment', as: :comment
    end
  end
  
  get 'profile/edit', to:'users#edit', as: :profile_edit
  
  
  get 'profile/(:id)', to:'users#show', as: :profile
  
  get 'follower_list/(:id)', to:'users#follower_list', as: :follower_list
  
  get 'follow_list/(:id)', to:'users#follow_list', as: :follow_list
  
  get 'sign_up', to:'users#sign_up', as: :sign_up
  
  get 'sign_in', to:'users#sign_in', as: :sign_in
  
  post 'sign_in', to:'users#sign_in_process'
  
  post 'sign_up', to:'users#sign_up_process'
  
  get 'sign_out', to:'users#sign_out', as: :sign_out
  
  post 'posts', to:'posts#create'
  
  get 'follow/(:id)', to:'users#follow', as: :follow
  
  # get 'profile/(:id)', to:'users#show', as: :profile
  
  
  # get 'posts/(:id)/like', to:'posts#like'
  
  # resources :posts do
  #   member do
  #     #いいね
  #     get 'like', to:'posts#like', as: :like
  #   end
  # end
  
  # post 'profile/edit' to:'users#update'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
