class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  before_save { email.downcase! }
  default_scope -> { order("#{table_name}.created_at DESC") }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }

  def feed
    Post.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  # To mark a post as a favorite
  def favorite!(post)
    favorites.create!(post_id: post.id)
  end

  # To undo or remove a favorite
  def undo_favorite!(post)
    favorites.find_by(post_id: post.id).destroy
  end

  def favorited?(post)
    favorites.find_by(post_id: post.id)
  end
end
