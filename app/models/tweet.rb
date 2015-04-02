class Tweet < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates  :tubuyaki,
    presence: true,
    length: { maximum: 255 }
  validates :user_id,
    presence: true
end