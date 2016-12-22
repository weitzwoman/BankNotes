require('spec_helper')

describe('the user route', {:type => :feature}) do
  it('will create a new user profile and login') do
    visit('/')
    click_link('Create New Account')
    fill_in('username', :with => 'Moneybags')
    fill_in('password', :with => 'secure')
    fill_in('password_confirmation', :with => 'secure')
    click_button('Create Account')
    fill_in('username', :with => 'Moneybags')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    expect(page).to have_content('Hello, Moneybags!')
  end
end
