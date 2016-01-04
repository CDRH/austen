# ruby 2.2 (not a shebang because I'm using rvm)
# make sure to run this from the root of the austen repository
# or you're gonna have a bad time because I'm using relative paths

require 'nokogiri'
require 'json'

@novels = {
  "aus.001.xml" => "pride_and_prejudice",
  "aus.002.xml" => "persuasion",
  "aus.003.xml" => "northanger_abbey",
  "aus.004.xml" => "sense_and_sensibility",
  "aus.005.xml" => "emma",
  "aus.006.xml" => "mansfield_park"
}

def read_novel(file_location)
  file = File.open(File.join(File.dirname(__FILE__), file_location))
  novel_xml = Nokogiri::XML(file)
  file.close
  return novel_xml
end

def run_all_xsl(input, output)
  puts "Making the overview for #{output}"
`saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/_#{output}.html.erb chapterid=chapter_all`
end

def run_chapter_xsl(input, output, chapter)
  `saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/#{output}/_chapter#{chapter}.html.erb chapterid=#{chapter}`
end

def run_frequency_xsl(input, output)
  if input == "aus.999.xml"
    puts "all novels"
    `saxon -s:public/#{input} -xsl:scripts/frequency_pages/austen_button_creator.xsl -o:app/views/frequencies/_#{output}.html.erb all_novels=true`
  else
    `saxon -s:public/#{input} -xsl:scripts/frequency_pages/austen_button_creator.xsl -o:app/views/frequencies/_#{output}.html.erb`
  end
end

def user_message(msg)
  return "========================#{msg}========================"
end

def frequency
  puts user_message("Generating frequency views and json")

  # push a new fake novel onto the hash for "all"
  @novels["aus.999.xml"] = "all_novels"
  @novels.each do |filename, title|
    # frequency button view
    puts "Creating the frequency buttons for #{title}"
    run_frequency_xsl(filename, title)
    # read in the correct dataStore file
    raw_xml = read_novel("../dataStore/speakerData_#{filename}")

    # pull out all of the <p> tags that have an n id
    puts "Retrieving unique words for #{title} categories"
    categories = raw_xml.css("p[n]")
    categories.each do |category|
      type = category.attr('n').gsub(' ', '_')  # like fool, aus.001.charactername, female
      unique_word_count = category.attr('countOfUniqueWords')
      speeches = category.attr('speeches')
      # TODO can also get the speeches from the top of the documents
      # and so should perhaps be pulling that if no info found for an
      # individual, but will have to hash through capitalization issues first
      json = {
        "unique_words" => unique_word_count,
        "speeches" => speeches,
        "words" => {}
      }
      frequencies = category.css("w")

      # change frequencies.length to an integer if you want to restrict the number returned
      frequencies.length.times do |index|
        child = frequencies[index]
        if child
          word = child.text()
          num = child.attr('freq')
          json["words"][word] = num if (word && num)
        end
      end  # end of children looping
      # write the results to a file
      File.open(File.join(File.dirname(__FILE__), "../public/frequencies/#{title}/#{type}.json"), "w") do |file|
        file.write(JSON.pretty_generate(json))
      end
    end
  end
end

def views
  puts user_message("Generating novel views")
  @novels.each do |filename, title|
    puts "Working on #{title}"
    run_all_xsl(filename, title)
    novel_xml = read_novel("../public/#{filename}")

    # chapter generation
    chapters = novel_xml.css("div[type='chapter']")
    chapters.length.times do |index|
      chapter_num = (title == "northanger_abbey") ? index : index+1
      puts "-- chapter #{chapter_num}"
      run_chapter_xsl(filename, title, chapter_num)
    end
  end
end

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