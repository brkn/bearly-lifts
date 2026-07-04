# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :workouts, only: [:index, :show, :new, :create]

  resources :exercise_variations, only: [:index]

  get "progress", to: "progress#index", as: :progress
  get "progress/:id", to: "progress#show", as: :progress_lift

  # TODO: do
  # resource :progress, only: [:index, :show]

  resource :plan, only: [:new, :create, :edit, :update] do
    collection do
      get "exercises", to: "plans#exercises"
    end
  end

  root "home#index"
end
