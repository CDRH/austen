class SearchController < ApplicationController
  def search
    @page_class = "search"
    rows = 50

    params[:rows] = rows
    options = create_search_options(params)

    # Use original text highlighting instead of Solr 9 revision
    # Commented as Solr 9 revision seems to provide more context, but wanted
    # to document code to toggle behavior in case of future review
    #options['hl.method'] = "original"

    @docs = $solr.query(options)
    @total_pages = @docs[:pages]
    @facets = $solr.get_facets(options)
    # uses the view helper function "any_facets_selected?"
    if params["qtext"].present? && view_context.any_facets_selected?
      @title = "Search Results: \"#{params["qtext"]}\" - #{display_facets(params)}"
    elsif params["qtext"].present?
      @title = "Search Results: \"#{params["qtext"]}\""
    elsif view_context.any_facets_selected?
      @title = "Search Results: #{display_facets(params)}"
    else
      @title = "Search the Journals"
    end
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
    if options[:sort]
      # sort normally if a sort is given
      options[:sort] = "#{options[:sort]} asc" if (options[:sort] == "id")
      options[:sort] = "#{options[:sort]} desc" if options[:sort] == "score"
    else
      # if sort is not given
      #   default to id if no term searched
      #   use relevancy if there is a term searched
      options[:sort] = "score desc" if options[:qtext]
      options[:sort] = "id asc" if !options[:qtext]
    end
    return options
  end

  def display_facets(params)
    params.except(:action,:sort,:controller,:qfield,:qtext,:commit,:rows).values.compact_blank.join(" / ")
  end
end