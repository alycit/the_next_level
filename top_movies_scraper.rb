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

  def movie_rows
    weeks_ago = params[:weeks_ago].to_i
    doc = Nokogiri::HTML(open("#{SITE_URL}?rank_id=#{weeks_ago}&country=us"))
    doc.xpath(CONTENT_LOCATION)
  end

  def convert_format data
    if params[:format] == 'xml'
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
  movies = MovieProcessor.process_movies movie_rows
  convert_format movies
end

get '/top_movies/:id.:format' do
  movie_id = params[:id].to_i
  return oops("This service only provides box office data for the top 50 movies") if( movie_id < 1 && movie_id > 50)

  movie = MovieProcessor.extract_movie movie_rows[movie_id - 1]
  convert_format movie
end

def oops(msg)
  @msg = msg
  status(404)
end

not_found do
  status(404)
  @msg || "I know not what you seek"
end
