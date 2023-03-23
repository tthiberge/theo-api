Rails.application.routes.draw do
  resources :listings do
    resources :missions, only: [:index]
  end

  root to: "listings#index"

end
