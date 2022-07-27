Rails.application.routes.draw do
  resources :api_keys
  devise_for :users
  get '/word', to: 'word#getWord'
  get '/definition', to: "word#getDefinitions"
  get '/example', to: "word#getExamples"
  get '/synonym', to: "word#getSynonyms"
  get '/antonym', to: "word#getAntonyms"
  get '/allWords', to: "word#getAllWords"
  root "index#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
