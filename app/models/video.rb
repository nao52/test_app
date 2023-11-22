class Video < ApplicationRecord
  belongs_to :channel

  validates :channel_id, presence: true, uniqueness: true
  validates :title, presence: true

  def self.popular_videos(access_token)
    popular_videos = []
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.authorization = Signet::OAuth2::Client.new(access_token: access_token)
    videos = service.list_videos(:snippet, my_rating: 'like', max_results: 1000)
    videos.items.each do |video|
      popular_videos << find_or_create_from_popular_videos(video)
    end
    popular_videos
  end

  private

  def self.find_or_create_from_popular_videos(video)
    video_params = video_params_from_popular_videos(video)
    find_or_create_by(video_id: video_params[:video_id]) do |video|
      video.update(video_params)
    end
  end

  def self.video_params_from_popular_videos(video)
    channel = Channel.find_or_create_by_channel_id(video.snippet.channel_id)
    {
      video_id: video.id,
      title: video.snippet.title,
      description: video.snippet.description,
      channel_id: channel.id
    }
  end
end
