class League < ApplicationRecord
  validates :name, uniqueness: true
end
