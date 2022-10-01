class Relationship < ApplicationRecord
  # Userテーブルから関連付けするが、フォローするユーザーとフォローされるユーザーを分ける必要があるため、クラス名を指定する
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
