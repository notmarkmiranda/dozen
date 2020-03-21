class Setting < ApplicationRecord
  belongs_to :settable, polymorphic: true
end
