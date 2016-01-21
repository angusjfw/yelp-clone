class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_repeat_reviews

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating).merge(user: current_user)
  end

  def reject_repeat_reviews
    if current_user.already_reviewed? Restaurant.find(params[:restaurant_id])
      flash[:alert] = 'You have already reviewed this restaurant.'
      redirect_to '/restaurants' and return
    end
  end
end
