# frozen_string_literal: true

class MediaManage < ApplicationRecord
  belongs_to :user
  has_many :media_time_span, dependent: :destroy
  mount_uploader :thumbnail, ThumbnailUploader

  def youtube_thumbnail_url
    return if media_url.nil?

    reg = media_url.match(%r{https://www\.youtube\.com/watch\?v=(?<id>.+?)\z})
    return nil if reg.nil?

    # 320x180
    "http://img.youtube.com/vi/#{reg[:id]}/mqdefault.jpg"
  end
end
