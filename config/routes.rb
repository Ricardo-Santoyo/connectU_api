Rails.application.routes.draw do
  default_url_options :host => "localhost"

  namespace :api, defaults: { format: :json } do
    resources :users, only: [:show] do
      resources :posts, only: [:index, :show, :create, :destroy]
    end
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
