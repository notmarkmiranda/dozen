require 'rails_helper'

describe UserDecorator, type: :decorator do
  let(:email) { "userdecorator@spec.com" }
  let(:user) do 
    create(:user, 
      email: email, 
      first_name: first_name, 
      last_name: last_name
    ).decorate
  end
  
  describe '#full_name_or_email' do
    subject(:full_name_or_email) { user.full_name_or_email }
    
    describe 'without first or last name' do
      let(:first_name) { nil }
      let(:last_name) { nil }
      
      it 'returns email address' do
        expect(full_name_or_email).to eq(email)
      end
    end
    
    describe 'with first name only' do
      let(:first_name) { "Mark" }
      let(:last_name) { nil }
      
      it 'returns first name only' do
        expect(full_name_or_email).to eq(first_name)
      end
    end
    
    describe 'with first and last name' do
      let(:first_name) { "Mark" }
      let(:last_name) { "Miranda" }
      
      it "returns first name and last initial" do
        expect(full_name_or_email).to eq("#{first_name} #{last_name}")
      end
    end
  end
end
