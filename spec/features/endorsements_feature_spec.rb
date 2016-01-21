require 'rails_helper'

feature 'endorsing reviews' do
  before do
    kfc = Restaurant.create(name: 'KFC')
    kfc.reviews.create(rating: 3, thoughts: 'It was an abomination')
  end

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    visit '/restaurants'
    click_link 'Endorse review'
    expect(page).to have_content('1 endorsement')
  end

  context 'review with multiple endorsements' do
    scenario 'dispays the correct count of endorsements' do
      visit '/restaurants'
      click_link 'Endorse review'
      click_link 'Endorse review'
      expect(page).to have_content('2 endorsements')
    end
  end
end
