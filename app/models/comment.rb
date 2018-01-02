class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, polymorphic: true

  validates :body, presence: true
  validates :post_id, :post_type, presence: true
  validates :user_id, presence: true
end
