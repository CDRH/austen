class AboutController < ApplicationController
  
  def sub
    @sub_name = params[:name]
  end
  
end
