Rails.application.routes.draw do
  get 'roles/index'
  get 'actors/index', as: 'actors_list'
  get 'actors/show'
  get 'genres/index', as: 'genres_list'
  get 'genres/show'
  get 'movies/index', as: 'movies_list'
  get 'movies/show'
  get 'welcome/index'
  root 'welcome#index'

  resources :genres, :movies, :actors, :roles
  ActiveAdmin.routes(self)
end

