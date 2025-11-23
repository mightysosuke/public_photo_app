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

  describe "GET /oauth/callback" do
    let(:mock_response) { instance_double(Net::HTTPResponse) }
    let(:token_response) { { access_token: "test_access_token" }.to_json }

    before do
      allow(Net::HTTP).to receive(:post_form).and_return(mock_response)
      allow(mock_response).to receive(:body).and_return(token_response)
    end

    context "認可コードが渡された場合" do
      it "photos_pathにリダイレクトすること" do
        get oauth_callback_path, params: { code: "test_code" }
        expect(response).to redirect_to(photos_path)
      end
    end
  end
end
