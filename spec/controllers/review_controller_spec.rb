require 'rails_helper'

describe ReviewsController, type: :controller do
  describe 'checking user is logged in before adding reviews' do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  describe 'do not allow repeat reviews' do
    it { is_expected.to use_before_action :reject_repeat_reviews }
  end

  describe 'DELETE#destroy' do
    let!(:joe){User.create(email: 'joebloggs@test.com', 
                      password: 'password', 
                      password_confirmation: 'password')}
    let!(:wendy){User.create(email: 'wendy01@test.com', 
                      password: 'password', 
                      password_confirmation: 'password')}
    let!(:kfc){Restaurant.create(user: joe, name: 'KFC')}
    let!(:kfc_review){Review.create(restaurant: kfc, user: joe, rating: 5)}
    
    xit 'only allows reviewer to delete review' do
      puts 'here we are'
      session[:user_id] = joe.id
      delete restaurant_review_path(kfc.id, kfc_review.id)
      expect(Review.all).to be_empty?
    end

    xit 'does not allow others to delete review' do
      session[:user_id] = wendy.id
      delete restaurant_review_path(kfc.id, kfc_review.id)
      expect(Review.all).to_not be_empty?
    end
  end
end
