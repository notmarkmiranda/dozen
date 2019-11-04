require 'rails_helper'

describe User, type: :model do
  describe 'validations'
  
  describe 'relationships' do
    it { should have_many :memberships }
  end
  
  describe 'methods'
end