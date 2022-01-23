class Bookmark < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :category, presence: true, length: { maximum: 50 }

  belongs_to :user

  with_options presence: true do
    validates :url, format: {with: /\A#{URI::regexp(%w(http https))}\z/}
  end
end
