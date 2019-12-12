require 'rails_helper'

describe User, type: :model do
  describe 'validations'
  
  describe 'relationships' do
    it { should have_many :memberships }
  end
  
  describe 'methods' do
    let(:user) { create(:user) }

    describe 'shared leagues' do
      let(:admin_membership) { create(:membership, user: user, role: 1) }
      let!(:admin_league) { admin_membership.league }
      let(:member_membership) { create(:membership, user: user, role: 0) }
      let!(:member_league) { member_membership.league }

      describe '#admin_leagues' do
        subject(:admin_leagues) { user.admin_leagues }

        it 'returns admined leagues' do
          expect(admin_leagues).to include(admin_league)
          expect(admin_leagues).not_to include(member_league)
        end
      end

      describe '#member_leagues' do
        subject(:member_leagues) { user.member_leagues }

        it 'returns member leagues' do
          expect(member_leagues).to include(member_league)
          expect(member_leagues).not_to include(admin_league)
        end
      end
    end
  end
end
