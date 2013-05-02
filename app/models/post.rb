class Post < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  has_attached_file :photo, :styles => { medium: "300x300>", thumb: "100x100>", default_url: "" }
  validates :user_id, presence: true
  validates :content, presence: true
end
