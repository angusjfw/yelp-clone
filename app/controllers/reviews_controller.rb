class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_repeat_reviews, except: [:destroy]

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.created_by? current_user
      @review.destroy
      flash[:notice] = 'Review deleted successfully.'
    else
      flash[:alert] = 'You can only delete your own reviews.'
    end
    redirect_to '/restaurants'
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
