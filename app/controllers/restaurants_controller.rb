class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def new
  end

  def create
    Restaurant.create(restaurant_params)
    redirect_to '/restaurants'
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
