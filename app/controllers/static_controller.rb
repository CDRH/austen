class StaticController < ApplicationController
  def index
    @page_class = "home"
  end

  def frequency
    @page_class = "frequency"
  end
end
