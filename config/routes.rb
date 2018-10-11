Rails.application.routes.draw do
  get 'role/index'
  get 'actor/index'
  get 'genre/index'
  get 'movie/index'
  get 'welcome/index'
  root 'welcome#index'

  resources :genres, :movies, :actors, :roles
  ActiveAdmin.routes(self)
end

