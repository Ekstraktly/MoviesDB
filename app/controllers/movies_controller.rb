class MoviesController < ApplicationController
  def index
    @movies = Movie.search(params[:term])
  end

  def show
    @movie = Movie.find(params[:id])

    require 'uri'
    require 'net/http'

    url = URI("https://api.themoviedb.org/3/movie/#{params[:id]}?language=en-US&api_key=e95ef8f8eb154d4d0fb1ba5d47cb66fc")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"
    response = http.request(request)
    # TODO error if unable to get live score?
    @current_score = JSON.parse(response.read_body)['vote_average']
  end

  def movie_params
    params.require(:movie).permit(:title)
  end
end
