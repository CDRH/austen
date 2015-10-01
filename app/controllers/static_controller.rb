class StaticController < ApplicationController
  def index
    @page_class = "home"
  end

  def xml
    redirect_to "#{ENV['RAILS_RELATIVE_URL_ROOT']}/#{params['id']}"
  end
end
