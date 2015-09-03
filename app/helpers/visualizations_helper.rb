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

  # starting chapter being 4, jump being like -1 or 1, generally
  # in order to go to chapter 3 or chapter 5 but allowing craziness
  # like jumping to page 2 from 12 etc
  def chapter_link(book_id, book, starting, jump)
    min_chapter = book["prelude"] ? 0 : 1
    total_chapters = book["chapters"]
    go_to_chapter = starting.to_i + jump
    is_chapter = (go_to_chapter <= total_chapters) && (go_to_chapter >= min_chapter)
    if is_chapter
      return visual_chapter_path(book_id, go_to_chapter)
    elsif jump > 0
      # if you were headed forward but can't get there just go to last chapter
      return visual_chapter_path(book_id, total_chapters)
    else
      # if you were headed backwards but can't get there just go to the first
      return visual_chapter_path(book_id, 1)
    end
  end
end
