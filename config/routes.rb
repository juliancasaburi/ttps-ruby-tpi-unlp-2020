Rails.application.routes.draw do
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :books
      get '/books/:id/notes', to: "books#book_notes"
      resources :notes
      get '/notes/:id/export', to: "notes#export"
    end
  end
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'users/registrations#create'
    post '/login', to: 'users/sessions#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
end
