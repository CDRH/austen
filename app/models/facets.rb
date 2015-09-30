module Facets

  def self.facet_list
    return [
      :novel, 
      :speaker_name, 
      :sex, 
      :marriage_status, 
      :class_status,
      :character_type,
      :age, 
      :occupation, 
      :mode_of_speech,
      :speaker_id
    ]
  end

  def self.facet_list_strings
    return facet_list.map do |item|
      item.to_s
    end
  end
end