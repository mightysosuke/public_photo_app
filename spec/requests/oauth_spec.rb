require 'rails_helper'

RSpec.describe "Oauth", type: :request do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: "password" }
  end

  describe "GET /oauth/authorize" do
    it "リダイレクトすること" do
      get oauth_authorize_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
