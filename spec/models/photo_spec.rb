require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'バリデーション' do
    context 'titleが30文字以内、かつ空でない場合' do
      let(:photo) { build(:photo, title: 'a' * 30) }

      it '保存できること' do
        expect(photo).to be_valid
      end
    end

    context 'titleが空の場合' do
      let(:photo) { build(:photo, title: nil) }

      it '保存できないこと' do
        expect(photo).not_to be_valid
      end
    end

    context 'titleが30文字を超える場合' do
      let(:photo) { build(:photo, title: 'a' * 31) }

      it '保存できないこと' do
        expect(photo).not_to be_valid
      end
    end

    context 'imageが空の場合' do
      let(:photo) { build(:photo, image: nil) }

      it '保存できないこと' do
        expect(photo).not_to be_valid
      end
    end
  end
end
