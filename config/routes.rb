# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "sign_up", to: "registrations#new"
  # Defines the root path route ("/")
  # root "articles#index"
end
