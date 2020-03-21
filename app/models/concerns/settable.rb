module Settable
  extend ActiveSupport::Concern

  included do
    has_many :settings, as: :settable
  end
end