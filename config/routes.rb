Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  resources :users
  get 'calendar/index'
  get 'prinzi_cal/index'
  resources :buchungs
  resources :verfugbarkeits
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'prinzi_cal#index', as: 'prinzi'

  #shortcuts
  # get 'calendar',to: 'calendar#index'
  # get 'calendar/success', to: 'calendar#success'
  # get 'calendar/list_events', to: 'calendar#list_events'
  # get 'calendar/new_buchung', to: 'calendar#new_buchung', as: 'new_buchung_cal'

  # post 'calendar/verfugbarkeits', to: 'calendar#create', as: 'calendar_verfugbarkeits'
  # post 'calendar/authorize', to: 'calendar#authorize', as: 'calendar_authorize'
  # post 'calendar/disconnect', to: 'calendar#disconnect', as: 'calendar_disconnect'

  get 'prinzi_cal/new_buchung', to: 'prinzi_cal#new_buchung', as: 'new_buchung_prinzi'
  post 'prinzi_cal/verfugbarkeits', to: 'prinzi_cal#create', as: 'prinzi_verfugbarkeits'

end
