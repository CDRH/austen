Rails.application.routes.draw do

  root 'static#index', as: :home
  get 'search' => 'search#search', as: :search
  get 'word_frequency' => 'frequency#index', as: :freq_index

  # visualizations
  get 'visualizations' => 'visualizations#index', as: :visual_index
  get 'visualizations/:id' => 'visualizations#table_of_contents', as: :visual_toc
  get 'visualizations/:id/all' => 'visualizations#all', as: :visual_all
  get 'visualizations/:id/:chapter' => 'visualizations#chapter', as: :visual_chapter

  get 'essays' => 'essays#index', as: :essays


end