class Photo < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :title, presence: true
  validates :image, presence: true
  validates :title, length: { maximum: 30 }
end
