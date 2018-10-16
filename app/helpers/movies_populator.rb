require 'open-uri'
require 'uri'
require 'net/http'

class MoviesPopulator
  def self.populate_movies
    (1..5).each do |page|
      url = URI("https://api.themoviedb.org/3/movie/top_rated?api_key=e95ef8f8eb154d4d0fb1ba5d47cb66fc&language=en-US&page=#{page}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request.body = "{}"

      response = http.request(request)

      JSON.parse(response.read_body)['results'].select do |movie|
        new_movie = Movie.create('title': movie['title'],
                                 'year': movie['release_date'].partition('-')[0],
                                 'overview': movie['overview'],
                                 'score': movie['vote_average'],
                                 'genre_id': movie['genre_ids'][0])
        new_movie.grab_image(File.join('https://image.tmdb.org/t/p/w500', movie['poster_path']),
                         movie['poster_path'][1..-1])
        puts "THIS MOVIE IS ADDED TO DATABASE: ",
             movie['title'],
             movie['release_date'].partition('-')[0],
             movie['vote_average']
      end
    end
    return
  end

  def self.populate_genres
    url = URI("https://api.themoviedb.org/3/genre/movie/list?api_key=e95ef8f8eb154d4d0fb1ba5d47cb66fc&language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)

    JSON.parse(response.read_body)['genres'].select do |genre|  #consider using map instead of select?
      Genre.create('name': genre['name'],
                   'id': genre['id'])
      puts genre['name'] + ' created'
    end
    return
  end
end