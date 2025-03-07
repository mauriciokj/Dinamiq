Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount ActionCable.server => "/cable"
# Cria enquete
resources :polls, only: [ :index,  :create, :show ]
  post "/polls/:token/vote", to: "votes#create"
  get "/polls/:token/check_vote", to: "votes#check_vote"

  # Defines the root path route ("/")
  # root "posts#index"
end
