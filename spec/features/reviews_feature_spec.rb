require 'rails_helper'
require 'session_helper'

feature 'reviewing' do
	before {Restaurant.create name: 'KFC'}

	scenario 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'

		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('so so')
	end

  scenario 'deletes a review if its parent restaurant deleted' do
    sign_up_user
    visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
    click_link 'Delete KFC'

    expect(Review.all).to eq []
  end
end
