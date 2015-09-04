# ruby 2.2 (not a shebang because I'm using rvm)
# make sure to run this from the root of the austen repository
# or you're gonna have a bad time because I'm using relative paths

require 'nokogiri'
require 'json'

novels = {
  "aus.001.xml" => "pride_and_prejudice",
  "aus.002.xml" => "persuasion",
  "aus.003.xml" => "northanger_abbey",
  "aus.004.xml" => "sense_and_sensibility",
  "aus.005.xml" => "emma",
  "aus.006.xml" => "mansfield_park"
}

def run_all_xsl(input, output)
  puts "Making the overview for #{output}"
`saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/_#{output}.html.erb chapterid=chapter_all`
end

def run_chapter_xsl(input, output, chapter)
  `saxon -s:public/#{input} -xsl:scripts/visualizations/chapter_generation.xsl -o:app/views/visualizations/#{output}/_chapter#{chapter}.html.erb chapterid=#{chapter}`
end

def run_frequency_xsl(input, output)
  `saxon -s:public/#{input} -xsl:scripts/frequency_pages/austen_button_creator.xsl -o:app/views/frequencies/_#{output}.html.erb`
end

puts "==========================\nGenerating full book views\n=========================="


novels.each do |filename, title|
  run_all_xsl(filename, title)
end



puts "==========================\nGenerating chapter views\nand frequency button views\n=========================="

# open each novel and store in memory

novels.each do |filename, title|
  puts "Working on #{title}"
  file = File.open(File.join(File.dirname(__FILE__), "../public/#{filename}"))
  novel_xml = Nokogiri::XML(file)
  file.close

  # chapter generation
  chapters = novel_xml.css("div[type='chapter']")
  chapters.length.times do |index|
    chapter_num = (title == "northanger_abbey") ? index : index+1
    puts "-- chapter #{chapter_num}"
    run_chapter_xsl(filename, title, chapter_num)
  end

  # frequency button view
  puts "Creating the frequency buttons for #{title}"
  run_frequency_xsl(filename, title)
end



puts "==========================\nGenerating frequency numbers\n=========================="

novels.each do |filename, title|
  # read in the correct dataStore file
  file = File.open(File.join(File.dirname(__FILE__), "../dataStore/speakerData_#{filename}"))
  raw_xml = Nokogiri::XML(file)
  file.close

  # pull out all of the <p> tags that have an n id
  categories = raw_xml.css("p[n]")
  categories.each do |category|
    type = category.attr('n')  # like fool, aus.001.charactername, female
    unique_word_count = category.attr('countOfWordsUniqueToThisSpeaker')
    speeches = category.attr('speeches')
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
