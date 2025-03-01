Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :students, only: [ :create, :destroy ]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/schools/:school_id/classes/:class_id/students", to: "students#index"
  get "/schools/:school_id/classes", to: "school_classes#index"
  # Defines the root path route ("/")
  # root "posts#index"
end
