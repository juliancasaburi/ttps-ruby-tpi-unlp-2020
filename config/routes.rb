Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'users/registrations#create'
    post '/login', to: 'users/sessions#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
end
