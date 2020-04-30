require 'rails_helper'

describe Setting, type: :model do
  describe 'relationships' do
    it { should belong_to :settable }
  end

  describe 'validations'

  describe 'methods'
end
