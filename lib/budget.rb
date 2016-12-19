class Budget < ActiveRecord::Base
  has_many(:transactions)
  belongs_to(:user)
end
