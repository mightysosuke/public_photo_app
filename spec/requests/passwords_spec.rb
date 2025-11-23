require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user) }

  describe "GET /passwords/new" do
    it "successのステータスが返ってくること" do
      get new_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /passwords" do
    context "登録されているemailを入力した場合" do
      it "リセットメールが送られて、リダイレクトすること" do
        expect {
          post passwords_path, params: { email_address: user.email_address }
        }.to have_enqueued_mail(PasswordsMailer, :reset).with(user)

        expect(response).to redirect_to(new_session_path)
        follow_redirect!
        expect(response.body).to include("reset instructions sent")
      end
    end

    context "登録されているemailを入力していない場合" do
      it "リダイレクトするが、リセットメールが送られていないこと" do
        expect {
          post passwords_path, params: { email_address: "missing-user@example.com" }
        }.not_to have_enqueued_mail

        expect(response).to redirect_to(new_session_path)
        follow_redirect!
        expect(response.body).to include("reset instructions sent")
      end
    end
  end

  describe "GET /passwords/:token/edit" do
    context "適切なトークンがパラメータに設定されている場合" do
      it "successのステータスが返ってくること" do
        get edit_password_path(user.password_reset_token)
        expect(response).to have_http_status(:success)
      end
    end

    context "適切なトークンがパラメータに設定されていない場合" do
      it "新しいパスワード登録画面に遷移すること" do
        get edit_password_path("invalid token")
        expect(response).to redirect_to(new_password_path)
        expect(flash[:alert]).to include("reset link is invalid")
      end
    end
  end

  describe "PUT /passwords/:token" do
    context "パスワードと確認用パスワードが一致している場合" do
      it "パスワードが更新されて、リダイレクトすること" do
        expect {
          put password_path(user.password_reset_token), params: { password: "new", password_confirmation: "new" }
        }.to change { user.reload.password_digest }

        expect(response).to redirect_to(new_session_path)
        follow_redirect!
        expect(response.body).to include("Password has been reset")
      end
    end

    context "パスワードと確認用パスワードが一致していない場合" do
      it "パスワードが更新されず、編集画面にリダイレクトすること" do
        token = user.password_reset_token
        expect {
          put password_path(token), params: { password: "no", password_confirmation: "match" }
        }.not_to change { user.reload.password_digest }

        expect(response).to redirect_to(edit_password_path(token))
        expect(flash[:alert]).to include("Passwords did not match")
      end
    end
  end
end
