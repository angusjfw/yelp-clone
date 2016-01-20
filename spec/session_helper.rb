def sign_up_user
  visit '/restaurants'
  click_link 'Sign up'
  fill_in 'user_email', with: 'joeb@test.com'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: 'password'
  click_button 'Sign up'
end

