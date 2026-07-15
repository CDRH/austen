module ApplicationHelper
  def site_title
    "Austen Said"
  end

  def full_title(page_title = nil)
    if page_title.present?
      "#{page_title} | #{site_title}"
    else
      site_title
    end
  end
end
