class Channel < ApplicationRecord
  require 'google/apis/youtube_v3'

  has_many :subscription_channels, dependent: :destroy
  has_many :users, through: :subscription_channels, source: :user
  has_many :videos, dependent: :destroy

  validates :channel_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :subscriber_count, presence: true

  def self.subscription_channels(access_token)
    subscription_channels = []
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.authorization = Signet::OAuth2::Client.new(access_token: access_token)
    subscriptions = service.list_subscriptions(:snippet, mine: true, max_results: 100)
    subscriptions.items.each do |item|
      channel_id = item.snippet.resource_id.channel_id
      subscription_channels << find_or_create_from_subscription(channel_id)
    end
    subscription_channels
  end

  private

  def self.find_or_create_from_subscription(channel_id)
    channel_params = channel_params_from_user_subscription(channel_id)
    find_or_create_by(channel_id: channel_params[:channel_id]) do |channel|
      channel.update(channel_params)
    end
  end

  def self.channel_params_from_user_subscription(channel_id)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = Settings.google_api_key
    channel_info = service.list_channels("snippet,statistics", id: channel_id).items[0]
    {
      channel_id: channel_id,
      thumbnail_url: channel_info.snippet.thumbnails.medium.url,
      name: channel_info.snippet.title,
      subscriber_count: channel_info.statistics.subscriber_count,
      description: channel_info.snippet.description
    }
  end
end
