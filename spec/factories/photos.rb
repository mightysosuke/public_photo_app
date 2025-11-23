FactoryBot.define do
  factory :photo do
    title { "テスト画像" }
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.png'), 'image/png') }
  end
end
