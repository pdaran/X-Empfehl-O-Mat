# frozen_string_literal: true

Rails.application.routes.draw do
  get 'recommender', to: 'recommender#category'
  get 'recommender/:id', to: 'recommender#articles'
  post 'recommender/:id', to: 'recommender#articles'
  get 'result', to: 'recommender#result'
  get 'homepage/index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "homepage#index"
end
