require 'sidekiq/web'

GameSocial::Application.routes.draw do
  match 'teams/new_for_tournament/:tournament_id', to: 'teams#new_for_tournament', as: 'new_team_for_tournament', via: [:get] 
  match 'teams/:id/join', to: 'teams#join', as: 'join_team', via: [:get]
  match 'teams/:id/leave', to: 'teams#leave', as: 'leave_team', via: [:get]
  resources :teams
  match 'tournaments/:id/rounds/:bracket_id/concede', to: 'tournaments#concede', as: 'concede_tournament_round', via: [:get] 
  match 'tournaments/:id/rounds/:bracket_id/resolve', to: 'tournaments#resolve', as: 'resolve_tournament_round', via: [:post] 
  match 'tournaments/:id/lock', to: 'tournaments#lock', as: 'lock_tournament', via: [:get] 
  match 'tournaments/new_for_event/:event_id', to: 'tournaments#new_for_event', as: 'new_tournament_for_event', via: [:get] 
  resources :tournaments

  match 'playlists/:id', to: 'playlists#add_game', as: 'add_game', via: [:post]
  match 'playlists/:id/:game_id', to: 'playlists#delete_game', as: 'delete_game', via: [:delete]
  resources :playlists

  match 'groups/:id/join', to: 'groups#join', as: 'join_group', via: [:get]
  match 'groups/:id/join/:user_id', to: 'groups#join', as: 'join_user_group', via: [:get]
  match 'groups/:id/leave', to: 'groups#leave', as: 'leave_group', via: [:get]
  match 'groups/:id/leave/:user_id', to: 'groups#leave', as: 'leave_user_group', via: [:get]
  match 'groups/:id/invite', to: 'groups#invite', as: 'invite_group', via: [:get]
  match 'groups/:id/invite', to: 'groups#send_invite', as: 'send_invite_group', via: [:post]
  resources :groups

  resources :posts

  match 'game_events/new_for_event/:event_id', to: 'game_events#new_for_event', as: 'new_game_event_for_event', via: [:get] 
  match 'posts/new_for_event/:event_id', to: 'posts#new_for_event', as: 'new_post_for_event', via: [:get] 
  match 'posts/new_for_game_event/:game_event_id', to: 'posts#new_for_game_event', as: 'new_post_for_game_event', via: [:get] 
  match 'game_events/:id/join', to: 'game_events#join', as: 'join_game_event', via: [:get]
  match 'game_events/:id/join/:user_id', to: 'game_events#join', as: 'join_user_game_event', via: [:get]
  match 'game_events/:id/leave', to: 'game_events#leave', as: 'leave_game_event', via: [:get]
  match 'game_events/:id/leave/:user_id', to: 'game_events#leave', as: 'leave_user_game_event', via: [:get]
  match 'game_events/:id/invite', to: 'game_events#invite', as: 'invite_game_event', via: [:get]
  match 'game_events/:id/invite', to: 'game_events#send_invite', as: 'send_invite_game_event', via: [:post]
  resources :game_events

  match 'events/:id/join', to: 'events#join', as: 'join_event', via: [:get]
  match 'events/:id/join/:user_id', to: 'events#join', as: 'join_user_event', via: [:get]
  match 'events/:id/leave', to: 'events#leave', as: 'leave_event', via: [:get]
  match 'events/:id/leave/:user_id', to: 'events#leave', as: 'leave_user_event', via: [:get]
  match 'events/:id/invite', to: 'events#invite', as: 'invite_event', via: [:get]
  match 'events/:id/invite', to: 'events#send_invite', as: 'send_invite_event', via: [:post]
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
  match 'users/:id/games', to: 'users#add_game', as: 'user_game_path', via: [:post]
  resources :users do
    get :autocomplete_user_name, :on => :collection
  end
  resources :users

  resources :games
  root to: 'users#home'
  match 'auth/steam/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/google_oauth2/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/developer/callback', to: 'sessions#create', via: [:get, :post]
 
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]


  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end unless Rails.env.development?
  mount Sidekiq::Web => '/sidekiq'
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
    "#{event_path(args.first.id)}.ics?auth_token=#{current_user.remember_token}&noCache" if current_user
  end

  def events_ics_path(*args)
    "#{events_path}.ics?auth_token=#{current_user.remember_token}&noCache"if current_user  
  end

  def game_events_ics_path(*args)
    "#{game_events_path}.ics?auth_token=#{current_user.remember_token}&noCache" if current_user
  end

  def new_source_game_social_server_path(*args)
    "#{game_social_servers_path}/new_source"
  end

  def invite_game_event_path(*args)
    "#{game_event_path(args.first.id)}/invite"
  end

  def invite_event_path(*args)
    "#{event_path(args.first.id)}/invite"
  end

  def user_game_path(*args)
    "#{user_path(args.first.id)}/games"
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
    :new_source_game_social_server_path,
    :invite_game_event_path,
    :invite_event_path
  ]
end


