class VisualizationsController < ApplicationController
  def index
    @page_class = "visualizations"
  end

  # show overview of all the chapters at once
  def all
    @page_class = "visualizations"
    @book = Books.get_book(params["id"])
  end

  def chapter
    @book = Books.get_book(params["id"])
  end

  def table_of_contents
    @page_class = "visualizations"
    @book = Books.get_book(params["id"])
  end
end