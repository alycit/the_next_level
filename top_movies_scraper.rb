require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'xmlsimple'

SITE_URL = "http://www.rottentomatoes.com/movie/box_office.php"
CONTENT_LOCATION = '//table[@class="center rt_table"]/tbody/tr'

helpers do 
  def process_movies rows
    movie_array = Array.new
    rows.each do |row|
      movie_array << extract_movie(row)
    end
    movie_array
  end

  def extract_movie row
    movie = Hash.new
    cells = row.xpath('td')

    movie["rank"] = cells[0].text
    movie["previous_rank"] = cells[1].text
    movie["tomato_meter_score"] = cells[2].xpath('span/span[@class="tMeterScore"]').text
    movie["name"] = cells[3].xpath('a').text
    movie["weeks_released"] = cells[4].text
    movie["weekend_gross"] = cells[5].text
    movie["total_gross"] = cells[6].text
    movie["theater_average"] = cells[7].text
    movie["number_of_theaters"] = cells[8].text

    movie
  end

  def convert_format data, format
    case format
    when "xml"
      data_hash = Hash.new
      data_hash["movie"] = data
      content_type :xml
      XmlSimple.xml_out data_hash, {"RootName" => "movies", "NoAttr" => true}
    else
      content_type :json
      data.to_json
    end
  end
end

get '/top_movies.:format' do
  doc = Nokogiri::HTML(open(SITE_URL))
  movies = process_movies doc.xpath(CONTENT_LOCATION)
  convert_format movies, params[:format]
end

get '/top_movies/:id.:format' do
  movie_id = params[:id].to_i

  if !(1..50).include?(movie_id)
    status(404)
    @msg = "This service only provides box office data for the top 50 movies"
    return
  end

  doc = Nokogiri::HTML(open(SITE_URL))
  movie = extract_movie doc.xpath(CONTENT_LOCATION)[movie_id - 1]
  convert_format movie, params[:format]
end

not_found do 
  status(404)
  @msg || "I know not what you seek"
end
