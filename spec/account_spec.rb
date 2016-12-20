require 'spec_helper'

describe Account do
  it { should belong_to(:user)}
  it { should have_many(:transactions)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:balance)}
end
