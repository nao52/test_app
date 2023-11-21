Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  root 'static_pages#top'
  resources :users, only: %i[new create] do
    member do
      get :channels
    end
  end
  resources :password_resets, only: %i[new create edit update]
  resources :channels, only: %i[index]
  
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  get 'auth/:provider/callback', to: 'google_login_api#callback'
  get 'auth/failure', to: redirect('/')
end
