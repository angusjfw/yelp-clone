require 'rails_helper'
require 'session_helper'

describe 'reviewing features' do
  let!(:joe){User.create(email: 'joeb@test.com', 
                         password: 'password', 
                         password_confirmation: 'password')}
  let!(:kfc){Restaurant.create(name: 'KFC', user: joe)}

  feature 'displaying reviews' do
    scenario 'shows a reviews average rating' do
      Review.create(restaurant: kfc, rating: 5)
      Review.create(restaurant: kfc, rating: 3)
      visit '/restaurants'
      expect(page).to have_content('Average rating: 4')
    end
  end

  feature 'leaving reviews' do
    scenario 'allows users to leave a review using a form' do
      sign_in('joeb@test.com')
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    context 'user not logged in' do
      scenario 'does not allow user to leave review' do
        visit '/restaurants'
        click_link 'Review KFC'
        expect(page).to have_content "You need to sign in or sign up before "\
                                       "continuing." 
      end
    end

    context 'user already reviewed restaurant' do
      scenario 'does not allow user to leave review' do
        sign_in('joeb@test.com')
        visit '/restaurants'
        click_link 'Review KFC'
        fill_in "Thoughts", with: "so so"
        select '3', from: 'Rating'
        click_button 'Leave Review'
        click_link 'Review KFC'
        expect(page).to have_content 'You have already reviewed this restaurant.' 
      end
    end
  end

  feature 'deleting reviews' do
    before(:each) do
      sign_up 'joebloggs@test.com'
      create_restaurant(name: 'Joes')
      leave_review(restaurant_name: 'Joes')
    end

    scenario 'deletes a review if its parent restaurant deleted' do
      visit '/restaurants'
      click_link 'Delete Joes'
      expect(Review.all).to eq []
    end

    scenario 'reviewers can delete their own reviews' do
      visit '/restaurants'
      click_link 'Delete review'
      expect(Review.all).to eq []
      expect(page).not_to have_content('5/5')
      expect(page).to have_content('Review deleted successfully.')
    end

    scenario 'reviewers can not delete other user reviews' do
      sign_up('wendy@test.com')
      visit '/restaurants'
      expect(page).not_to have_content('Delete review')
    end
  end
end
