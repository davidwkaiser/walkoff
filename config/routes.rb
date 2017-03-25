Rails.application.routes.draw do
  get 'welcome/index'
  resources :games
  resources :tweets

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
