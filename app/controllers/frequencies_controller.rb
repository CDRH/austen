class FrequenciesController < ApplicationController
  def index
    @page_class = "frequency"
  end

  def json
    @novel = params[:novel]
    @id = params[:id]
    begin
      @data = File.read("public/frequencies/#{@novel}/#{@id}.json")
    rescue
      puts "No data found for #{@novel} - #{@id}"
      @data = {
        "unique_words" => "0",
        "speeches" => "???",
        "words" => { "No unique words" => "Not. One." }
      }
    end
    render :json => @data
  end
end