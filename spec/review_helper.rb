module ReviewHelpers
  def create_restaurant(name: 'KFC')
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: name
    click_button 'Create Restaurant'
  end

  def leave_review(restaurant_name: 'KFC', rating: 3, thoughts: 'so so')
    visit '/restaurants'
    click_link "Review #{restaurant_name}"
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end
end
