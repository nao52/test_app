class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :subscription_channels, dependent: :destroy
  has_many :channels, through: :subscription_channels, source: :channel
  has_many :popular_videos, dependent: :destroy
  has_many :videos, through: :popular_videos, source: :video

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :remember_me_token, uniqueness: true, allow_nil: true

  def add_subscriptions(subscription_channels)
    channels.delete_all if channels.present?
    subscription_channels.each do |channel|
      channels << channel unless channels.include?(channel)
    end
  end

  def add_popular_videos(popular_videos)
    videos.delete_all if videos.present?
    popular_videos.each do |video|
      videos << video unless videos.include?(video)
    end
  end
end
