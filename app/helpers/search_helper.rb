module SearchHelper

  def any_facets_selected?
    selected = false
    for key in Facets.facet_list do
      if params.has_key?(key)
        selected = true
      end
    end
    return selected
  end

  def selected_class(selected)
    return "class=selected" if selected
  end

end
