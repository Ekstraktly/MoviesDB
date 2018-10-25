class GenresController < ApplicationController
  def index
    @genres = Genre.search(params[:term])
  end

  def show
    @genre = Genre.find(params[:id])
    @movies = @genre.movies
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
