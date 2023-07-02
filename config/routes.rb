# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root

  scope ':locale' do
    get 'recommender', to: 'recommender#products'
    post 'recommender', to: 'recommender#products'
    get 'result', to: 'recommender#result'

    get 'homepage/index'
    root 'homepage#index'

    get '/info', to: 'homepage#info', as: 'info'
    get '/impressum', to: 'homepage#impressum', as: 'impressum'
    get '/privacy', to: 'homepage#privacy', as: 'privacy'
    get '/contact', to: 'homepage#contact', as: 'contact'

    get 'registrations', to: 'registrations#index', as: 'registrations'
    get 'sessions', to: 'sessions#index', as: 'sessions'

    resources :registrations, only: %i[new create] do
      collection do
        get :new_user
        post :create_user
        get :new_shop
        post :create_shop
      end
    end

    resources :sessions, only: %i[new create] do
      collection do
        get :new_user
        post :create_user
        get :new_shop
        post :create_shop
      end
    end

    resources :passwords, only: %i[reset update] do
      collection do
        get :edit_user
        patch :update_user
        get :edit_shop
        patch :update_shop
        get :reset
        patch :send_reset
      end
    end

    resources :passwords, only: [:update] do
      patch :update_user, on: :collection
    end

    get 'sign_in', to: 'sessions#new_user'
    post 'sign_in', to: 'sessions#create_user'
    delete 'logout', to: 'sessions#destroy_user'

    get 'login', to: 'sessions#new_shop'
    post 'login', to: 'sessions#create_shop'
    delete 'logout_shop', to: 'sessions#destroy_shop'

    get 'register', to: 'registrations#new_shop'
    post 'register', to: 'registrations#create_shop'

    get '/dashboards', to: 'dashboards#index'
    get '/dashboard/recommendation', to: 'dashboards#recommendation', as: 'dashboard_recommendation'
    resources :password_resets

    resources :shops do
      resources :categories do
        get :kiosk_mode
        resources :attrs
        resources :products do
          resources :attrs
        end
      end
    end
  end
end
