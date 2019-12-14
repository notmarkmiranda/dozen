class Membership < ApplicationRecord
  self.implicit_order_column = 'created_at'

  belongs_to :user
  belongs_to :league
  
  enum role: [:member, :admin]
end
