module SearchHelper

  ################
  #  Pagination  #
  ################

  def paginator_numbers(total_pages)
    current_page = params[:page] ? params[:page].to_i : 1
    total_pages = total_pages.to_i
    html = ""
    # weed out the first and last page, they'll be handled separately
    prior_three = (current_page-3..current_page-1).reject { |x| x <= 1 }
    next_three = (current_page+1..current_page+3).reject { |x| x >= total_pages }

    # add the first page if you're not on it and add dots if it is far from the other pages
    if current_page != 1
      html += "<li>"
      html += link_to "1", to_page("1") 
      html += "</li>"
      html += "<li class='disabled'><span>...</span></li>" if prior_three.min != 2 && current_page != 2
    end

    # prior three, current page, and next three
    html += _add_paginator_options(prior_three)
    html += "<li class='active'>"
    html += link_to current_page.to_s, to_page(current_page)
    html += "</li>"
    html += _add_paginator_options(next_three)

    # add the last page if you're not on it and add dots if it is far from the other pages
    if current_page != total_pages
      html += "<li class='disabled'><span>...</span></li>" if next_three.max != total_pages-1 && current_page != total_pages-1
      html += "<li>"
      html += link_to total_pages.to_s, to_page(total_pages)
      html += "</li>"
    end

    return html.html_safe
  end

  def _add_paginator_options(range)
    html = ""
    range.each do |page|
      html += "<li>"
      html += link_to page.to_s, to_page(page)
      html += "</li>"
    end
    return html
  end

  def result_text(number)
    text = number == 1 ? "result" : "results"
    return text
  end

  def to_page(page)
    merged = params.merge({:page => page.to_s})
    return merged
  end

  ##############
  #  Faceting  #
  ##############

  def any_facets_selected?
    selected = false
    for key in Facets.facet_list do
      if params.has_key?(key)
        selected = true
      end
    end
    return selected
  end

  def facet_link(facet_type, facet)
    # make a new set of params and make sure not to alter the original ones
    new_params = params.clone
    reset_params(new_params)
    new_params[facet_type] = facet
    return new_params
  end

  def facet_selected?(facet_type, facet)
    # this is just a really handy debug line, so I'm keeping it
    # puts "facet type #{facet_type}, facet #{facet}, and in params #{params[facet_type]}"
    return params[facet_type] == facet
  end

  def remove_facet(facet_type, facet)
    new_params = params.clone
    reset_params(new_params)
    new_params.delete(facet_type)
    return new_params
  end

  def reset_params(aParams)
    aParams.delete("facet.field")
    aParams.delete(:page)
    return aParams
  end

  def selected_class(selected)
    return "class=selected" if selected
  end

  ###########
  #  Other  #
  ###########

  def sort(sort_type)
    params[:sort] = sort_type
    return params
  end

end
