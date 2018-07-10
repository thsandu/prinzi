Rails.application.routes.draw do
  get 'prinzi_cal/index'
  resources :buchungs
  resources :verfugbarkeits
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prinzi_cal#index', as: 'prinzical'
end
