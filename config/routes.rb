# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "articles#index"
  # get "/articles", to: "articles#index"
  # get "/articles/:id", to: "articles#show"
  resources :categories
  # do products
  resources :articles do 
    resources :comments
  end
  
  # Rails provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. This is a shortcut for:
  # get "/articles", to: "articles#index"
  # get "/articles/new", to: "articles#new", as: "new_article"
  # post "/articles", to: "articles#create"
  # get "/articles/:id", to: "articles#show", as: "article"
  # get "/articles/:id/edit", to: "articles#edit", as: "edit_article"
  # patch "/articles/:id", to: "articles#update"
  # delete "/articles/:id", to: "articles#destroy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html  
end
