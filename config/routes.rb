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

    get '/impressum', to: 'homepage#impressum', as: 'impressum'
    get '/privacy', to: 'homepage#privacy', as: 'privacy'
    get '/contact', to: 'homepage#contact', as: 'contact'
    get 'registrations', to: 'registrations#index', as: 'registrations'
    get 'sessions', to: 'sessions#index', as: 'sessions'

    resources :registrations, only: %i[new create] do
      collection do
        get :new_user
        post :create_user
      end
    end
    resources :registrations, only: %i[new ,create] do
      collection do
        get :new_shop
        post :create_shop
      end
    end

    resources :sessions, only: %i[new ,create] do
      collection do
        get :new_shop
        post :create_shop
      end
    end

    resources :sessions, only: %i[new ,create] do
      collection do
        get :new_user
        post :create_user
      end
    end

    resources :passwords, only: [] do
      collection do
        get :edit_user
        patch :update_pass_user
      end
    end

    resources :passwords, only: [] do
      collection do
        get :edit_shop
        patch :update_pass_shop
      end
    end

    get 'sign_in', to: 'sessions#new_user'
    post 'sign_in', to: 'sessions#create_user'

    get 'sign_in_shop', to: 'sessions#new_shop'
    post 'sign_in_shop', to: 'sessions#create_shop'

    get 'password', to: 'passwords#edit', as: :edit_password
    patch 'password', to: 'passwords#update'

    delete 'logout', to: 'sessions#destroy_user'

    delete 'logout_shop', to: 'sessions#destroy_shop'

    get '/dashboards', to: 'dashboards#index'

    resources :shops do
      resources :categories do
        resources :attrs
        resources :products do
          resources :attrs
        end
      end
    end
  end
end
