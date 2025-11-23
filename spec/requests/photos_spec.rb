require 'rails_helper'

RSpec.describe "Photos", type: :request do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: "password" }
  end

  describe "GET /photos" do
    context "リクエストを送った場合" do
      it "successのステータスが返ってくること" do
        get photos_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /photos/new" do
    it "successのステータスが返ってくること" do
      get new_photo_path
      expect(response).to have_http_status(:success)
    end
  end
end
