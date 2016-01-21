require 'rails_helper'
require 'session_helper'

feature 'reviewing' do
	before do
    create_user('joeb@test.com')
    Restaurant.create(name: 'KFC', user: User.first)
  end

	scenario 'allows users to leave a review using a form' do
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
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'

      expect(page).to have_content "You need to sign in or sign up before "\
                                     "continuing." 
    end
  end


  context 'user already reviewed restaurant' do
    xscenario 'does not allow user to leave review' do
    end
  end


  scenario 'deletes a review if its parent restaurant deleted' do
    visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
    sign_in 'joeb@test.com'
    click_link 'Delete KFC'

    expect(Review.all).to eq []
  end
end
