class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # set up SOLR configuration for the website
  solr_url = CONFIG['solr_url']
  if solr_url
    $solr = RSolrCdrh::Query.new(solr_url, [
      "novel", 
      "speaker_name", 
      "sex", 
      "marriage_status",
      "class_status",
      "age",
      "occupation",
      "mode_of_speech",
      "speaker_id"
      ])
    # there is no title field to sort on
    $solr.set_default_query_params({
      :sort => "id asc"
    })
  else
    raise "No Solr URL found for Austen rails project, cannot continue!"
  end

end
