Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'blood_pressures#index'
  post 'import_data', to: 'blood_pressures#import_data'
  resources :blood_pressures

  get 'signup', to: 'users#new'
  get 'login',  to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'print',  to: 'blood_pressures#printable_table'
  get 'printable_table', to: 'blood_pressures#printable_table'
  get 'time_stuff',      to: 'blood_pressures#time_stuff'

  resources :users
  resources :sessions
  # get 'sessions/new'
end
