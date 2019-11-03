require 'rails_helper'

describe League, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of :name }
  end
  
  describe 'relationships'
  describe 'methods'
end
