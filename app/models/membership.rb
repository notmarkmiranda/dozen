class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :league
  
  enum role: [:member, :admin]
end
