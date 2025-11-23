require 'rails_helper'

RSpec.describe "Photos", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    visit new_session_path
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_button "ログインする"
  end

  describe "写真一覧ページ" do
    it "新規アップロードリンクが表示されること" do
      visit photos_path
      expect(page).to have_link("写真を新規にアップロード")
    end

    it "Twitter連携リンクが表示されること" do
      visit photos_path
      expect(page).to have_link("Twitterと連携")
    end

    it "ログアウトリンクが表示されること" do
      visit photos_path
      expect(page).to have_link("ログアウト")
    end

    context "写真が存在しない場合" do
      it "ページが表示されること" do
        visit photos_path
        expect(page).to have_content("写真一覧")
      end

      it "写真のタイトルが表示されないこと" do
        visit photos_path
        expect(page).not_to have_content("テスト写真")
      end

      it "写真の画像が表示されないこと" do
        visit photos_path
        expect(page).not_to have_css("img.photo-image")
      end
    end

    context "写真が存在する場合" do
      let!(:photo) { create(:photo, user: user, title: "テスト写真") }

      it "写真のタイトルが表示されること" do
        visit photos_path
        expect(page).to have_content("テスト写真")
      end

      it "写真の画像が表示されること" do
        visit photos_path
        expect(page).to have_css("img.photo-image")
      end
    end

    context "Twitter連携していない場合" do
      it "ツイートボタンが表示されないこと" do
        visit photos_path
        expect(page).not_to have_button("ツイートする")
      end
    end

    # sessionに値をセットする方法を調査する必要がある
    xcontext "Twitter連携している場合" do
      let(:photo) { create(:photo, user: user) }
      let(:session_hash) { { twitter_access_token: "access_token" } }

      it "ツイートボタンが表示されること" do
        visit photos_path
        expect(page).to have_button("ツイートする")
      end
    end
  end

  describe "写真新規アップロードページ" do
    before do
      visit new_photo_path
    end

    it "ページが表示されること" do
      expect(page).to have_content("写真アップロード")
    end

    it "タイトル入力フィールドが表示されること" do
      expect(page).to have_field("タイトル")
    end

    it "画像ファイル選択フィールドが表示されること" do
      expect(page).to have_field("画像ファイル")
    end

    it "アップロードボタンが表示されること" do
      expect(page).to have_button("アップロード")
    end

    it "キャンセルリンクが表示されること" do
      expect(page).to have_link("キャンセル")
    end

    context "有効な値を入力した場合" do
      it "写真がアップロードされて一覧ページに遷移すること" do
        fill_in "タイトル", with: "新しい写真"
        attach_file "画像ファイル", Rails.root.join('spec/fixtures/files/test.png')
        click_button "アップロード"

        expect(page).to have_current_path(photos_path)
        expect(page).to have_content("新しい写真")
      end
    end

    context "タイトルが空の場合" do
      it "エラーメッセージが表示されること" do
        attach_file "画像ファイル", Rails.root.join('spec/fixtures/files/test.png')
        click_button "アップロード"

        expect(page).to have_content("入力してください")
      end
    end

    context "画像が空の場合" do
      it "エラーメッセージが表示されること" do
        fill_in "タイトル", with: "タイトルのみ"
        click_button "アップロード"

        expect(page).to have_content("入力してください")
      end
    end

    context "キャンセルをクリックした場合" do
      it "一覧ページに遷移すること" do
        click_link "キャンセル"
        expect(page).to have_current_path(photos_path)
      end
    end
  end
end
