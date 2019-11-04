require 'rails_helper'

describe Membership, type: :model do
  describe 'validations'
  
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :league }
  end
  
  describe 'methods'
end
