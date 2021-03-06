Rails.application.routes.draw do

  root 'static#index', as: :home
  get 'search' => 'search#search', as: :search
  get 'xml/:id' => 'static#xml', as: :xml, :constraints => { :id => /[^\/]+/ }

  # frequencies
  get 'frequencies' => 'frequencies#index', as: :frequency
  get 'frequencies/:novel/:id' => 'frequencies#json', as: :freq_json, :constraints => { :id => /[^\/]+/ }

  # visualizations
  get 'visualizations' => 'visualizations#index', as: :visual_index
  get 'visualizations/:id' => 'visualizations#table_of_contents', as: :visual_toc
  get 'visualizations/:id/all' => 'visualizations#all', as: :visual_all
  get 'visualizations/:id/:chapter' => 'visualizations#chapter', as: :visual_chapter

  get 'background' => 'background#index', as: :background
  
  get 'about' => 'about#index', as: :about
  get 'about/:name' => 'about#sub', as: :about_sub
end
