require('spec_helper')

describe('the accounts path', {:type => :feature}) do
  it('will modify a user\'s accounts') do
    user = User.create({:name => 'Moneybags', :password => 'secure'})
    visit('/')
    fill_in('username', :with => 'Moneybags')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    fill_in('account_name', :with => 'Savings')
    fill_in('initial_balance', :with => '100')
    click_button('Add Account')
    expect(page).to have_content('Savings')
    click_link("change_history")
    fill_in('name', :with => 'Checking')
    click_button('Update')
    expect(page).to have_content('Checking')
  end
end
