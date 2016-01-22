require 'rails_helper'
require 'session_helper'

describe 'restaurant features' do
  before do
    create_user('joeb@test.com')
  end
  let!(:joe){User.first}

  feature 'showing all restaurants' do
    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurant' do
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'restaurants have been added' do
      scenario 'displays restaurants' do
        Restaurant.create(name: 'KFC', user: joe)
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end

      scenario 'displays restaurant images' do
        sign_in('joeb@test.com')
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        page.attach_file('Image', Rails.root + 'spec/test_image.png')
        click_button 'Create Restaurant'
        expect(current_path).to eq '/restaurants'
        expect(page).to have_xpath("//img[contains(@src, \"thumb/test_image.png\")]")
      end
    end
  end

  feature 'creating restaurants' do
    scenario 'prompts user to fill form, then displays the new restaurant' do
      sign_in('joeb@test.com')
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_in('joeb@test.com')
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KF'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'KF'
        expect(page).to have_content 'error'
      end
    end

    context 'user not logged in' do
      scenario 'does not let you create restaurants when not logged in' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).not_to have_css 'h2', text: 'KFC'
        expect(page).to have_content "You need to sign in or sign up before "\
                                     "continuing." 
      end
    end

    feature 'uploading images' do
      scenario 'adds image to restaurant db record' do
        sign_in('joeb@test.com')
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        page.attach_file('Image', Rails.root + 'spec/test_image.png')
        click_button 'Create Restaurant'
        expect(current_path).to eq '/restaurants'
        expect(Restaurant.first.image_file_name).not_to be_empty
      end
    end
  end

  feature 'viewing restaurant pages' do
    let!(:kfc){Restaurant.create(name: 'KFC', user: joe)}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  feature 'editing restaurants' do
    before do
      Restaurant.create(name: 'KFC', user: joe)
    end

    scenario 'let the creator edit a restaurant' do
      sign_in('joeb@test.com')
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    context 'wrong user is signed in' do
      scenario 'does not allow editing' do
        sign_out
        sign_up('wendy@test.com')
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(page).to have_content 'A restaurant can only be edited by the owner.'
      end
    end
  end

  feature 'deleting restaurants' do
    before do
      Restaurant.create(name: 'KFC', user: joe)
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_in('joeb@test.com')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    context 'wrong user is signed in' do
      it 'does not allow deleting' do
        sign_out
        sign_up('wendy@test.com')
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(page).to have_content 'A restaurant can only be edited by the owner.'
      end
    end
  end
end
