module Books

  def self.book_list
    return {
      "pride_and_prejudice" => {
        "xml" => "aus.001.xml",
        "chapters" => 61,
        "title" => "Pride and Prejudice"
      },
      "persuasion" => {
        "xml" => "aus.002.xml",
        "chapters" => 24,
        "title" => "Persuasion"
      },
      "northanger_abbey" => {
        "xml" => "aus.003.xml",
        "chapters" => 31,
        "prelude" => true,  # has a chapter 0
        "title" => "Northanger Abbey"
      },
      "sense_and_sensibility" => {
        "xml" => "aus.004.xml",
        "chapters" => 50,
        "title" => "Sense and Sensibility"
      },
      "emma" => {
        "xml" => "aus.005.xml",
        "chapters" => 55,
        "title" => "Emma"
      },
      "mansfield_park" => {
        "xml" => "aus.006.xml",
        "chapters" => 48,
        "title" => "Mansfield Park"
      }
    }
  end

  def self.get_book id
    return book_list[id.downcase]
  end
end