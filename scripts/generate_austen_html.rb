# Generate Austen HTML Script
#   Jessica Dussault jduss4
#   Spring 2016
#
#
# ruby 2.2 (not a shebang because of rvm)
# ruby scripts/generate_austen_html.rb
#
# Coerces XML files with unique word freuqency information
#   into JSON and creates an HTML view for frequency exploration
# Creates visualization HTML for each chapter and novel

require 'nokogiri'
require 'json'

#######################################
#              Variables              #
#######################################

@novels = {
  "aus.001.xml" => "pride_and_prejudice",
  "aus.002.xml" => "persuasion",
  "aus.003.xml" => "northanger_abbey",
  "aus.004.xml" => "sense_and_sensibility",
  "aus.005.xml" => "emma",
  "aus.006.xml" => "mansfield_park"
}

@categories = nil  # will be created for each novel

#######################################
#          General Helpers            #
#######################################

def fresh_categories
  # these are the categories that will be displayed by default
  # in the html view
  return {
    "speakerData" => {"label" => "Character Direct Speech", "data" => []},
    "indirectData" => {"label" => "Character Indirect Diction", "data" => []},
    "traitData" => {"label" => "Trait: Character Type", "data" => []}, 
    "genderData" => {"label" => "Trait: Character Sex", "data" => []},
    "maritalStateData" => {"label" => "Trait: Character Marriage Status", "data" => []},
    "socecStatusData" => {"label" => "Trait: Character Class Status", "data" => []},
    "ageData" => {"label" => "Trait: Character Age", "data" => []},
    "occupationData" => {"label" => "Trait: Character Occupation", "data" => []},
  }
end

def read_novel(file_path_from_repo)
  file = File.open("#{File.dirname(__FILE__)}/../#{file_path_from_repo}")
  novel_xml = Nokogiri::XML(file)
  file.close
  return novel_xml
end

def user_message(msg)
  return "======================== #{msg} ========================"
end

def write_to_file(file_path_from_repo, text)
  File.open("#{File.dirname(__FILE__)}/../#{file_path_from_repo}", 'w') do |file|
    file.write(text)
  end
end

#######################################
#        Frequency Generation         #
#######################################

def frequency
  puts user_message("Generating frequency views and json")

  # push a new fake novel onto the hash for "all"
  @novels["aus.999.xml"] = "all_novels"
  @novels.each do |filename, title|
    puts "Creating the frequency buttons for #{title}"
    raw_xml = read_novel("dataStore/speakerData_#{filename}")

    # pull out all of the <p> tags that have an n id
    puts "Retrieving unique words for #{title} categories"
    frequencies = raw_xml.css("p[n]")
    frequencies.each do |freq|
      generate_json(title, freq)  # create json snippets with the frequencies
    end
    generate_html(title, frequencies)  # create html button view
  end
end

def generate_html(title, frequencies)
  # start off with a branch new copy of the categories
  @categories = fresh_categories

  frequencies.each do |freq|
    populate_categories(freq)
    html = %{<div class='panel-group' id='accordion' role='tablist' aria-multiselectable='true'>\n}
    @categories.each do |category, items|
      # check if there is any data in the category
      if items["data"] && items["data"].length > 0
        collapsed = category == "speakerData" ? "in" : ""
        html += %{<div class='panel panel-default'>
          <div class='panel-heading' role='tab' id='#{title}_#{category}_heading'>
            <h4 class='panel-title'>
              <a class=''
                 role='button'
                 data-toggle='collapse'
                 data-parent='#accordion'
                 href='##{title}_#{category}_body'
                 aria-expanded='true'
                 aria-controls='#{title}_#{category}_body'>#{items["label"]}</a>
            </h4>
          </div>
          <div id='#{title}_#{category}_body' class='panel-collapse collapse #{collapsed}'
              role='tabpanel' aria-labelledby='#{title}_#{category}_heading'>
            <div class='panel-body'>
          }
        buttons = ""
        items["data"].each do |item|
          href = item[0].gsub(" ", "_")
          buttons += %{<a class='btn btn-default btn-xs' href='##{href}' role='button' data='#{title}'>#{item[1]}</a>\n}
        end
        html += buttons
        html += %{</div>\n</div>\n</div>\n}
      end
    end
    html += %{</div>\n}
    # verify that it is valid xml, then write to file
    output = Nokogiri::XML(html, &:noblanks)  # ignore whitespace
    write_to_file("app/views/frequencies/_#{title}.html.erb", output.to_xml(indent:2))
  end
end

# make a json file that has the list of unique words for each trait / character
def generate_json(title, freq)
  type = freq.attr('n').gsub(' ', '_')  # like fool, aus.001.charactername, female
  json = {
    "id" => freq.attr('n'),
    "display" => freq.attr('display'),
    "novel" => titleize(title),
    "unique_words" => freq.attr('countOfUniqueWords'),
    "speeches" => freq.attr('speeches'),
    "words" => {}
  }
  frequencies = freq.css("w")
  frequencies.length.times do |index|
    child = frequencies[index]
    if child
      word = child.text()
      num = child.attr('freq')
      json["words"][word] = num if (word && num)
    end
  end  # end of children looping
  write_to_file("public/frequencies/#{title}/#{type}.json", JSON.pretty_generate(json))
end

def populate_categories(freq)
  # associate each frequency with a parent category (like speaker, occupation, etc)
  parent = freq.parent
  if parent && parent.name
    if !@categories.has_key?(parent.name)
      @categories[parent.name] = {"label" => parent.name, "data" => []}
    end
    # pull out the id and the display name and put them in the categories
    id = freq.attribute("n").text()
    display = freq.attribute("display").text()
    if display != "N/A"
      if display.include?(" as ")
        # Narrator speaking as Wickham, etc
        @categories["indirectData"]["data"] << [id, display]
      else
        @categories[parent.name]["data"] << [id, display]
      end
    end
  end
end

def titleize(title)
  return title.gsub("_", " ").split.map(&:capitalize).join(' ')
end

#######################################
#            Visualizations           #
#######################################

def run_all_xsl(input, output)
  puts "Making the overview for #{output}"
`saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/_#{output}.html.erb chapterid=chapter_all`
end

def run_chapter_xsl(input, output, chapter)
  `saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/#{output}/_chapter#{chapter}.html.erb chapterid=#{chapter}`
end

def views
  puts user_message("Generating novel views")
  @novels.each do |filename, title|
    puts "Working on #{title}"
    run_all_xsl(filename, title)
    novel_xml = read_novel("public/#{filename}")

    # chapter generation
    chapters = novel_xml.css("div[type='chapter']")
    chapters.length.times do |index|
      chapter_num = (title == "northanger_abbey") ? index : index+1
      puts "-- chapter #{chapter_num}"
      run_chapter_xsl(filename, title, chapter_num)
    end
  end
end


#######################################
#                 Main                #
#######################################

puts %{Please select one:
    [a] only generate novel and chapter visualization
    [b] only generate word frequencies for all novels
    [c] everything, generate everything!
}
run_opt = gets.chomp.downcase  # get the user input, cut off extra characters, lowercase

if run_opt != "a"
  frequency
end
if run_opt != "b"
  views
end