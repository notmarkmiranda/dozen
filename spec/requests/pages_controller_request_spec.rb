require "rails_helper"

describe PagesController, type: :request do
  describe "GET#index" do
    subject(:get_index) { get root_path }
    
    it "has status 200" do
      get_index
    
      expect(response).to have_http_status(200)
    end
  end
end