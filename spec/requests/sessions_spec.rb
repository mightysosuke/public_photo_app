require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /session/new" do
    it "successのステータスが返ってくること" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /session" do
    context "正しい認証情報の場合" do
      it "ログインしてリダイレクトすること" do
        post session_path, params: { email_address: user.email_address, password: "password" }

        expect(response).to redirect_to(root_path)
        expect(cookies[:session_id]).to be_present
      end
    end

    context "パスワードが間違っている場合" do
      it "ログインできずエラーが表示されること" do
        post session_path, params: { email_address: user.email_address, password: "wrong" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(cookies[:session_id]).to be_nil
      end
    end
  end

  describe "DELETE /session" do
    it "ログアウトしてリダイレクトすること" do
      post session_path, params: { email_address: user.email_address, password: "password" }

      delete session_path

      expect(response).to redirect_to(new_session_path)
      expect(cookies[:session_id]).to be_empty
    end
  end
end
