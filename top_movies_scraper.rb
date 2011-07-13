require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'xmlsimple'
require './movie_processor'

SITE_URL = "http://www.rottentomatoes.com/movie/box_office.php"
CONTENT_LOCATION = '//table[@class="center rt_table"]/tbody/tr'

helpers do


  def convert_format data, format
    case format
    when "xml"
      data_hash = { :movie => data }
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
  movies = MovieProcessor.process_movies doc.xpath(CONTENT_LOCATION)
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
  movie = MovieProcessor.extract_movie doc.xpath(CONTENT_LOCATION)[movie_id - 1]
  convert_format movie, params[:format]
end

not_found do
  status(404)
  @msg || "I know not what you seek"
end
