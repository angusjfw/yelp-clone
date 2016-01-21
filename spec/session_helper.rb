module SessionHelpers
  def sign_up(email='joeb@test.com')
    visit '/restaurants'
    sign_out
    click_link 'Sign up'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'
  end

  def create_user(email='joeb@test.com')
    User.create(
      email: email,
      password: 'password',
      password_confirmation: 'password'
    )
  end

  def sign_in(email='joeb@test.com')
    visit '/restaurants'
    sign_out
    click_link 'Sign in'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: 'password'
    click_button 'Log in'
  end

  def sign_out
    if page.has_link? 'Sign out'
      click_link 'Sign out'
    end
  end
end
