Rails.application.routes.draw do
  # Use Devise's sign-in page as the root
  root to: "home#login"

  # Devise routes for user authentication
  devise_for :users, controllers: { sessions: "users/sessions", registrations: 'users/registrations'}

  # Resourceful routes for todos
  resources :todos, only: [ :new, :create, :edit, :update, :index, :destroy ]

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA service worker and manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
