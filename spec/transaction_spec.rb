require 'spec_helper'

describe(Transaction) do
  it { should belong_to(:account)}
  it { should belong_to(:user)}
  it { should belong_to(:budget)}
end
