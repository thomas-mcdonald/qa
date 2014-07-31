class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, polymorphic: true

  validates :post_id, presence: true
  validates :post_type, presence: true
  validates :body, presence: true
end
