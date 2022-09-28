Rails.application.routes.draw do
  get "homes/top"
  root to: "homes#top"
  
  resources :books
end
