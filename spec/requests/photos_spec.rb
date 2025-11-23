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

  describe "POST /photos" do
    let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.png'), 'image/png') }

    context "titleもimageも正常な値がリクエストされている場合" do
      it "写真が作成されてリダイレクトすること" do
        expect {
          post photos_path, params: { photo: { title: "新しい写真", image: image } }
        }.to change(Photo, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(photos_path)
      end
    end

    context "titleが空の場合" do
      it "写真が作成されずエラーが表示されること" do
        expect {
          post photos_path, params: { photo: { title: nil, image: image } }
        }.not_to change(Photo, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "imageが空の場合" do
      it "写真が作成されずエラーが表示されること" do
        expect {
          post photos_path, params: { photo: { title: "タイトル", image: nil } }
        }.not_to change(Photo, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /photos/:id/tweet" do
    let(:photo) { create(:photo, user: user) }
    let(:mock_response) { instance_double(Net::HTTPResponse) }

    before do
      allow(Net::HTTP).to receive(:start).and_return(mock_response)
    end

    context "ツイートが成功した場合" do
      before do
        allow(mock_response).to receive(:code).and_return("201")
      end

      it "リダイレクトしてnoticeが返されること" do
        post tweet_photo_path(photo)
        expect(response).to redirect_to(photos_path)
        expect(flash[:notice]).to eq("ツイートしました")
      end
    end

    context "ツイートが失敗した場合" do
      before do
        allow(mock_response).to receive(:code).and_return("400")
      end

      it "リダイレクトしてalertが返されること" do
        post tweet_photo_path(photo)
        expect(response).to redirect_to(photos_path)
        expect(flash[:alert]).to eq("ツイートに失敗しました")
      end
    end
  end
end
