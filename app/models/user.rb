class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :subscription_channels, dependent: :destroy
  has_many :channels, through: :subscription_channels, source: :channel

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :remember_me_token, uniqueness: true, allow_nil: true

  def add_subscriptions(subscriptions_channels)
    channels.delete_all
    subscriptions_channels.each do |channel|
      channels << channel unless subscription_channel?(channel)
    end
  end

  def subscription_channel?(channel)
    channels.include?(channel)
  end
end
