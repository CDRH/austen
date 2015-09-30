class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # set up SOLR configuration for the website
  solr_url = CONFIG['solr_url']
  if solr_url
    $solr = RSolrCdrh::Query.new(solr_url, Facets.facet_list_strings)
    # there is no title field to sort on
    $solr.set_default_query_params({
      :sort => "id asc",
      :hl => "true"
    })
    $solr.set_default_facet_params({
      "facet.limit" => "-1",
      "facet.mincount" => "1"
    })
  else
    raise "No Solr URL found for Austen rails project, cannot continue!"
  end

end
