class Video < ApplicationRecord
  belongs_to :channel_id

  validates :channel_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :video_url, presence: true, uniqueness: true
end
