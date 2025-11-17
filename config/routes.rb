Rails.application.routes.draw do
  devise_for :users
  
  root 'home#index'

  # Rotas do Admin
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :solicitantes
    resources :unidades
    resources :cnpjs
  end

  # Rotas do Solicitante
  namespace :solicitante do
    get 'dashboard', to: 'dashboard#index'
    resources :agendamentos
  end

  # Rotas públicas (se houver)
  get 'home', to: 'home#index'
end