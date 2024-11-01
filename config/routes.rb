Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: %i[create update destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]
end
