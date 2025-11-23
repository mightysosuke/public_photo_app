require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'メールアドレスの標準化' do
    context 'メールアドレスの前後に空白がある場合' do
      let(:user) { create(:user, email_address: '  test@example.com  ') }

      it '空白が削除されること' do
        expect(user.email_address).to eq('test@example.com')
      end
    end

    context 'メールアドレスが大文字の場合' do
      let(:user) { create(:user, email_address: 'TEST@EXAMPLE.COM') }

      it '小文字に変換されること' do
        expect(user.email_address).to eq('test@example.com')
      end
    end
  end
end
