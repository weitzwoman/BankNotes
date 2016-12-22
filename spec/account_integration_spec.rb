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
    click_button('delete_forever')
    expect(page).to_not have_content('Checking')
  end
  it('will sort accounts') do
    user = User.create({:name => 'Moneybags', :password => 'secure'})
    visit('/')
    fill_in('username', :with => 'Moneybags')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    account = Account.create({:name => 'Checking', :balance => 4000, :user_id => user.id})
    account1 = Account.create({:name => 'Savings', :balance => 6000, :user_id => user.id})
    visit('/user_account')
    click_link('sort_by_alpha')
    expect(page).to have_content('Checking 4000.0 change_history delete_forever Savings')
    click_link('monetization_on')
    expect(page).to have_content('Savings 6000.0 change_history delete_forever Checking')
  end
end
