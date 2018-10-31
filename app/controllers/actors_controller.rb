class ActorsController < ApplicationController
  def index
    @actors = Actor.search(params[:term])
  end

  def show
    @actor = Actor.find(params[:id])
    @roles = @actor.roles
  end

  def genre_params
    params.require(:actor).permit(:name)
  end
end
