require 'sidekiq/web'

GameSocial::Application.routes.draw do
  resources :posts

  match 'game_events/new_for_event/:event_id', to: 'game_events#new_for_event', as: 'new_game_event_for_event', via: [:get] 
  match 'posts/new_for_event/:event_id', to: 'posts#new_for_event', as: 'new_post_for_event', via: [:get] 
  match 'posts/new_for_game_event/:game_event_id', to: 'posts#new_for_game_event', as: 'new_post_for_game_event', via: [:get] 
  match 'game_events/:id/join', to: 'game_events#join', as: 'join_game_event', via: [:get]
  match 'game_events/:id/join/:user_id', to: 'game_events#join', as: 'join_user_game_event', via: [:get]
  match 'game_events/:id/leave', to: 'game_events#leave', as: 'leave_game_event', via: [:get]
  match 'game_events/:id/leave/:user_id', to: 'game_events#leave', as: 'leave_user_game_event', via: [:get]
  resources :game_events

  match 'events/:id/join', to: 'events#join', as: 'join_event', via: [:get]
  match 'events/:id/join/:user_id', to: 'events#join', as: 'join_user_event', via: [:get]
  match 'events/:id/leave', to: 'events#leave', as: 'leave_event', via: [:get]
  match 'events/:id/leave/:user_id', to: 'events#leave', as: 'leave_user_event', via: [:get]
  resources :events

  resources :alerts

  resources :alert_conditions

  resources :alert_schedules

  resources :game_locations

  resources :friendships

  match 'game_social_servers/new_source', to: 'game_social_servers#new_source', as: 'new_source_game_server', via: [:get]
  resources :game_social_servers

  resources :chat_servers

  match 'users/sync', to: 'users#sync', as: 'sync_users', via:[:get]
  match 'users/sync_location', to: 'users#sync_location', as: 'sync_users_location', via:[:get]
  resources :users

  resources :games
  root to: 'users#home'
  match 'auth/steam/callback', to: 'sessions#create', via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  mount Sidekiq::Web => '/sidekiq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

GameSocial::Application.routes.named_routes.module.module_eval do
  def new_game_event_for_event_path(*args)
    "#{game_events_path}/new_for_event/#{args.first.id}"
  end

  def new_post_for_event_path(*args)
    "#{posts_path}/new_for_event/#{args.first.id}"
  end

  def new_post_for_game_event_path(*args)
    "#{posts_path}/new_for_game_event/#{args.first.id}"
  end

  def event_ics_path(*args)
    "#{event_path(args.first.id)}.ics?auth_token=#{current_user.remember_token}&noCache"
  end

  def events_ics_path(*args)
    "#{events_path}.ics?auth_token=#{current_user.remember_token}&noCache"
  end

  def game_events_ics_path(*args)
    "#{game_events_path}.ics?auth_token=#{current_user.remember_token}&noCache"
  end

  def new_source_game_social_server_path(*args)
    "#{game_social_servers_path}/new_source"
  end
end

GameSocial::Application.routes.named_routes.instance_eval do
  @helpers += [
    :new_game_event_for_event_path,
    :new_post_for_event_path,
    :new_post_for_game_event_path,
    :event_ics_path,
    :events_ics_path,
    :game_events_ics_path,
    :new_source_game_social_server_path
  ]
end


