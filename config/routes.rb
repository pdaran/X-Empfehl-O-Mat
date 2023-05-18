# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root

  scope ':locale' do
    get 'recommender', to: 'recommender#category'
    get 'recommender/:id', to: 'recommender#articles'
    post 'recommender/:id', to: 'recommender#articles'
    get 'result', to: 'recommender#result'

    get 'homepage/index'
    root 'homepage#index'

    get 'sign_up', to: 'registrations#new'
    post 'sign_up', to: 'registrations#create'

    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create'

    get 'password', to: 'passwords#edit', as: :edit_password
    patch 'password', to: 'passwords#update'

    delete 'logout', to: 'sessions#destroy'

    get '/dashboards', to: 'dashboards#index'

    resources :articles do
      resources :comments
    end

    resources :categories do
      resources :products
    end
  end
end
