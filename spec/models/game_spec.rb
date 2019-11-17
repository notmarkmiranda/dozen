require 'rails_helper'

describe Game, type: :model do
  describe 'validations'

  describe 'relationships' do
    it { should belong_to(:season).without_validating_presence }
    it { should belong_to(:league).without_validating_presence }
  end

  describe 'methods'
end
