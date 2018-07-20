Rails.application.routes.draw do
  get 'calendar/index'
  get 'prinzi_cal/index'
  resources :buchungs
  resources :verfugbarkeits
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prinzi_cal#index', as: 'prinzical'

  #shortcuts
  get 'calendar',to: 'calendar#index'
  get 'calendar/success', to: 'calendar#success'
  get 'calendar/list_events', to: 'calendar#list_events'

end
