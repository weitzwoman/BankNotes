require 'spec_helper'

describe User do
  it {should have_many(:accounts)}
  it {should have_many(:budgets)}
  it {should have_many(:transactions)}
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:name)}
  it {should have_secure_password}
  it {should validate_presence_of(:password)}

  describe("#titleize_user") do
    it "titleizes username" do
      test_user = User.create({:name => 'codybruh', :password => '1234'})
      expect(test_user.name).to(eq('Codybruh'))
    end
  end

end
