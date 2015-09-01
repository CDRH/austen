class SearchController < ApplicationController
  def search
    @page_class = "search"
    rows = 50

    params[:rows] = rows
    options = create_search_options(params)

    @docs = $solr.query(options)
    @total_pages = (@docs[:num_found].to_f/rows).ceil
    @facets = $solr.get_facets(options)
  end


  private

  # leave params as is, then squish together the various facet fields
  # to prepare to send off via rsolr
  def create_search_options(aParams)
    options = aParams.clone
    fq = []
    for key in [:novel, :speaker_name, :sex, :marriage_status, :class_status, :age, :occupation, :mode_of_speech] do
      if options[key]
        fq << "#{key.to_s}:\"#{options[key]}\""
      end
    end
    options[:fq] = fq
    return options
  end
end
