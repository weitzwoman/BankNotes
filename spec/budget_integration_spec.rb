require('spec_helper')

describe('the budgets path', {:type => :feature}) do
  it('will modify a user\'s budgets') do
    user = User.create({:name => 'Pennywise', :password => 'secure'})
    visit('/')
    fill_in('username', :with => 'Pennywise')
    fill_in('password', :with => 'secure')
    click_button('Sign In')
    click_link('Budgets')
    fill_in('budget_name', :with => 'Rent')
    fill_in('budget_amount', :with => '500')
    click_button('Add Budget')
    expect(page).to have_content('Rent')
    click_link("change_history")
    fill_in('budget_name', :with => 'Mortgage')
    fill_in('budget_amount', :with => '1000')
    click_button('Update Budget')
    expect(page).to have_content('Mortgage')
    click_button('delete_forever')
    expect(page).to_not have_content('Mortgage')
  end
end
