require('spec_helper')

describe('the transactions path', {:type => :feature}) do
  it('will modify a user\'s transactions') do
    user = User.create({:name => 'George Washington', :password => 'secure'})
    visit('/')
    fill_in('username', :with => 'George Washington')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    click_link('Transactions')
    fill_in('category', :with => 'Groceries')
    fill_in('amount', :with => '200')
    fill_in('place', :with => 'Winco')
    fill_in('date', :with => '12-12-2016')
    click_button('Add Transaction')
    expect(page).to have_content('Groceries')
    # click_link("change_history")
    # fill_in('name', :with => 'Checking')
    # click_button('Update')
    # expect(page).to have_content('Checking')
    # click_button('delete_forever')
    # expect(page).to_not have_content('Checking')
  end
end
