class Transaction < ActiveRecord::Base
  belongs_to(:account)
  belongs_to(:budget)
  belongs_to(:user)
end
