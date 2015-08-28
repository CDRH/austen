class SearchController < ApplicationController
  def search
    @page_class = "search"
    if params.has_key?(:special)
      params[:qfield => "*"]
      params[:qtext => "*"]
    end
    @docs = $solr.query(params)    
    @facets = $solr.get_facets(params)
  end
end
