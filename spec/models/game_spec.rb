require 'rails_helper'

describe Game, type: :model do
  describe 'validations' do
    it { should validate_presence_of :buy_in }
  end

  describe 'relationships' do
    it { should belong_to(:season).without_validating_presence }
    it { should belong_to(:league).without_validating_presence }
  end

  describe 'methods'
end
