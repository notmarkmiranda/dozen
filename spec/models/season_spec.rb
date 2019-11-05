require 'rails_helper'

describe Season, type: :model do
  describe 'validations'
  
  describe 'relationships' do
    it { should belong_to :league }
  end
  
  describe 'methods'
end
