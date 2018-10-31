require 'open-uri'
require 'uri'
require 'net/http'

class MoviesPopulator
  def self.populate_movies
    (1..5).each do |page|
      response = getAPIResponse(page)

      JSON.parse(response.read_body)['results'].select do |movie|
        new_movie = Movie.create('id': movie['id'],
                                 'title': movie['title'],
                                 'year': movie['release_date'].partition('-')[0],
                                 'overview': movie['overview'],
                                 'score': movie['vote_average'],
                                 'genre_id': movie['genre_ids'][0])


        new_movie.grab_image(File.join('https://image.tmdb.org/t/p/w500', movie['poster_path']),
                         movie['poster_path'][1..-1])
        puts "THIS MOVIE WAS ADDED TO DATABASE: ",
             movie['title'],
             movie['release_date'].partition('-')[0],
             movie['vote_average']

        populateActors(new_movie.id)
        puts "ACTORS ARE POPULATED"
      end
    end
    nil
  end

  def self.populate_genres
    url = URI("https://api.themoviedb.org/3/genre/movie/list?api_key=#{Rails.application.credentials.moviedbAPI[:APIkey]}&language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)

    JSON.parse(response.read_body)['genres'].select do |genre|  # todo consider using map instead of select?
      Genre.create('name': genre['name'],
                   'id': genre['id'])
      puts genre['name'] + ' created'
    end
    nil
  end

  private

  def self.getAPIResponse(page)
    url = URI("https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.moviedbAPI[:APIkey]}&language=en-US&page=#{page}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"
    http.request(request)
  end

  def self.populateActors(movieID)
    url = URI("https://api.themoviedb.org/3/movie/#{movieID}?api_key=#{Rails.application.credentials.moviedbAPI[:APIkey]}&append_to_response=credits")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"
    response = http.request(request)
    JSON.parse(response.read_body)['credits']['cast'].first(10).select do |castMember|
      if !Actor.exists?(id: castMember['id'])
        new_actor = Actor.create('name': castMember['name'],
                              'id': castMember['id'])
        new_role = Role.create('movie_id': movieID,
                               'actor_id': new_actor.id,
                               'name': castMember['character'])
      end
    end
  end
end