Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Public routes
  root "pages#home"

  # Blog
  resources :posts, only: [ :index, :show ], path: "blog"

  # I18n - English routes
  scope "/:locale", locale: /en/ do
    root "pages#home", as: :localized_root
    resources :posts, only: [ :index, :show ], path: "blog", as: :localized_posts
  end

  # Admin
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root "dashboard#index"

    resource :personal_info, only: [ :show, :edit, :update ]
    resources :social_links, except: [ :show ]
    resources :experiences
    resources :educations
    resources :certifications
    resources :volunteerings
    resources :projects
    resources :skills
    resources :languages
    resources :posts
  end
end
