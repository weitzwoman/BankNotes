class Account < ActiveRecord::Base
  belongs_to(:user)
  validates(:name, :presence => true)
  validates(:balance, :presence => true)
end
