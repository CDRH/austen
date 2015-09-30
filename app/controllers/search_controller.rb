class SearchController < ApplicationController
  def search
    @page_class = "search"
    rows = 50

    params[:rows] = rows
    options = create_search_options(params)

    @docs = $solr.query(options)
    @total_pages = @docs[:pages]
    @facets = $solr.get_facets(options)
  end


  private

  # leave params as is, then squish together the various facet fields
  # to prepare to send off via rsolr
  # also put in sorting
  def create_search_options(aParams)
    options = aParams.clone
    fq = []
    for key in Facets.facet_list do
      if options[key]
        fq << "#{key.to_s}:\"#{options[key]}\""
      end
    end
    options[:fq] = fq
    options[:sort] = "#{options[:sort]} asc" if options[:sort] == "id"
    options[:sort] = "#{options[:sort]} desc" if options[:sort] == "score"
    return options
  end
end