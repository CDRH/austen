# ruby 2.2 (not a shebang because I'm using rvm)

require 'nokogiri'

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
`saxon -s:public/#{input} -xsl:scripts/chapter_generation.xsl -o:app/views/visualizations/_#{output}.html.erb chapterid=chapter_all`
end

def run_chapter_xsl(input, output, chapter)
  `saxon -s:public/#{input} -xsl:scripts/chapter_generation.xsl -o:app/views/visualizations/#{output}/_chapter#{chapter}.html.erb chapterid=#{chapter}`
end

puts "==========================\nGenerating full book views\n=========================="

novels.each do |filename, title|
  run_all_xsl(filename, title)
end

puts "==========================\nGenerating chapter views\n=========================="

# open each novel and store in memory
novels.each do |filename, title|
  puts "Working on #{title}"
  file = File.open(File.join(File.dirname(__FILE__), "../public/#{filename}"))
  novel_xml = Nokogiri::XML(file)
  file.close
  chapters = novel_xml.css("div[type='chapter']")
  chapters.length.times do |index|
    chapter_num = (title == "northanger_abbey") ? index : index+1
    puts "-- chapter #{chapter_num}"
    run_chapter_xsl(filename, title, chapter_num)
  end

end