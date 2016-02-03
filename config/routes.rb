Rails.application.routes.draw do
  #devise_for :users, :controllers => { :registrations => 'users' }

  resources :notes
  resources :users

  root :to => "static#index"

  get ':action' => 'static#:action'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
