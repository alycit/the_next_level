class MovieProcessor

  def self.process_movies rows
    rows.each_with_object([]) { |row, arr| arr << extract_movie(row) }
  end

  def self.extract_movie row
    cells = row.xpath('td')

    {
      :rank => cells[0].text,
      :previous_rank => cells[1].text,
      :tomato_meter_score => cells[2].xpath('span/span[@class="tMeterScore"]').text,
      :name => cells[3].xpath('a').text,
      :weeks_released => cells[4].text,
      :weekend_gross => cells[5].text,
      :total_gross => cells[6].text,
      :theater_average => cells[7].text,
      :number_of_theaters => cells[8].text
    }
  end

end
