require('spec_helper')

describe('the transactions path', {:type => :feature}) do
  it('will modify a user\'s transactions') do
    user = User.create({:name => 'George Washington', :password => 'secure'})
    visit('/')
    fill_in('username', :with => 'George Washington')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    account = Account.create({:name => 'Checking', :balance => 4000, :user_id => user.id})
    budget = Budget.create({:name => 'Food', :amount => 500, :user_id => user.id, :current_amount => 500, :type_of_budget => 'Monthly' })
    click_link('Accounts')
    click_link('Transactions')
    fill_in('category', :with => 'Groceries')
    fill_in('amount', :with => '200')
    fill_in('place', :with => 'Winco')
    fill_in('date', :with => '12-12-2016')
    select('Food', :from => 'budget_id')
    select('Checking', :from => 'account_id')
    click_button('Add Transaction')
    expect(page).to have_content('Groceries')
    click_link("change_history")
    fill_in('category', :with => 'Alcohol')
    click_button('Update')
    expect(page).to have_content('Alcohol')
    click_button('delete_forever')
    expect(page).to_not have_content('Alcohol')
  end
end
