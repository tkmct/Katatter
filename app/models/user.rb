class User < ActiveRecord::Base
  before_save { self.email = email.downcase}
  before_create :create_remember_token
  mount_uploader :image, ImageUploader
  validates :name,
    presence: true,
    uniqueness: true,
    length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: VALID_EMAIL_REGEX }

  has_secure_password

  validates :password,
    length: { minimum: 6 }

  VALID_USERID_REGEX = /\A@[0-9a-z]+\z/

  validates :userid,
    presence: true,
    uniqueness: true,
    format: { with:  VALID_USERID_REGEX }

    has_many :tweets, dependent: :destroy

    def User.new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def feed
      Tweet.where("user_id = ?", id)
    end

    private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end