module VisualizationsHelper

  def generate_chapter_links(id, num_chapters, start_at_zero=false)
    starting_chapter = start_at_zero ? 0 : 1
    if num_chapters.to_i
      html = "<ul>"
      for chapter in starting_chapter..num_chapters.to_i
        html += "<li>"
        html += link_to "Chapter #{chapter}", visual_chapter_path(id, chapter)
        html += "</li>"
      end
      html += "</ul>"
      return html
    end
  end
end
