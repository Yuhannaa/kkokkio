class Post < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorers, through: :favorites, source: :user
  default_scope -> { order("#{table_name}.created_at DESC") }
  validates :user_id, presence: true
  validates :content, presence: true

  if Rails.env.production?
    # uploading a file with a duplicate name will throw error. It should be improved
    has_attached_file :photo, :styles => { medium: "300x300>", thumb: "100x100>" },
                      :storage => :dropbox,
                      :dropbox_credentials => "#{Rails.root}/config/dropbox.yml",
                      :dropbox_options => { :path => proc { |style| "#{style}/#{id}_#{photo.original_filename}" } }
  else
    has_attached_file :photo, :styles => { medium: "300x300>", thumb: "100x100>", default_url: "" } 
  end

  # Returns posts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end
end
