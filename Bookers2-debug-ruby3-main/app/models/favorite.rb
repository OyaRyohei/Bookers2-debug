class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  
  # 一意性を持たせる（userは一つの投稿(book)につき1いいねしか付けられない）
  validates_uniqueness_of :book_id, scope: :user_id
end
