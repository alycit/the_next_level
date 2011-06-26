# Top Movies Scraper

# Usage

This scraper reads the top 50 movies as provided by the rottentomatoes.com box office listing and presents the data as a REST web service.  The data is presented in either xml or json format via the following urls

## All 50 movies

	HOSTNAME/top_movies.xml
	HOSTNAME/top_movies.json 

## Individual Movies

	HOSTNAME/top_movies/1.xml
	HOSTNAME/top_movies/1.json

## JSON Format

	{"rank":"7",
	"previous_rank":"6",
	"tomato_meter_score":"90%",
	"name":"Bridesmaids",
	"weeks_released":"7",
	"weekend_gross":"$7.1M",
	"total_gross":"$136.5M",
	"theater_average":"$2.8k",
	"number_of_theaters":"2573"}

## XML Format

	<movies>
		<movie>
			<rank>7</rank>
			<previous_rank>6</previous_rank>
			<tomato_meter_score>90%</tomato_meter_score>
			<name>Bridesmaids</name>
			<weeks_released>7</weeks_released>
			<weekend_gross>$7.1M</weekend_gross>
			<total_gross>$136.5M</total_gross>
			<theater_average>$2.8k</theater_average>
			<number_of_theaters>2573</number_of_theaters>
		</movie>
	</movies>


## Error Handling

Basic error handling is provided and provides a 404 to the user with the appropriate message for either an individual movie out of range or invalid url.  

