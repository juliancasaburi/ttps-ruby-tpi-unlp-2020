Rails.application.routes.draw do
  # Devise (Auth)
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'users/registrations#create'
    post '/login', to: 'users/sessions#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      # Books
      resources :books
      get 'exportBooks', to: "books#export"
      get '/books/:id/notes', to: "books#book_notes", constraints: { id: /[0-9]+/ }
      get '/books/:id/export', to: "books#export_book", constraints: { id: /[0-9]+/ }
      # Notes
      resources :notes
      get '/notes/:id/export', to: "notes#export", constraints: { id: /[0-9]+/ }
    end
  end
  # Swagger
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
