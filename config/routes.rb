Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: %i[create update destroy]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create update destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
