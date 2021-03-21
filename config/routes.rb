Rails.application.routes.draw do
  default_url_options :host => "localhost"

  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index, :show] do
      resources :posts, only: [:index, :show, :create, :destroy]
    end

    resources :comments, only: [:index, :show, :create, :destroy]

    resources :likes, only: [:create, :destroy]

    resources :following, only: [:create, :destroy]
  end

  devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'api/login',
      sign_out: 'api/logout',
      registration: 'api/signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }
end
