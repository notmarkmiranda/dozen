require 'rails_helper'

describe Player, type: :model do
  describe 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end

  pending 'validations'

  pending 'methods'
end
