# frozen_string_literal: true

class MediaManage < ApplicationRecord
  include CommonModule
  belongs_to :user
  has_many :media_time_span, dependent: :destroy
  has_many :media_time_image, dependent: :destroy
  mount_uploader :thumbnail, ThumbnailUploader

  def time_spans
    media_time_span.where(seq_id: curr_seq_id).sorted
  end

  def can_restore
    media_time_span.where(seq_id: curr_seq_id - 1).count.positive?
  end

  def media_sec_str
    sec_to_str(media_sec || 0)
  end

  def youtube_video_id
    return if media_url.nil?

    reg = media_url.match(%r{https://www\.youtube\.com/watch\?v=(?<id>.+?)\z})
    return reg[:id] unless reg.nil?

    reg = media_url.match(%r{https://youtu\.be/(?<id>.+?)\z})
    return reg[:id] unless reg.nil?

    nil
  end

  def youtube_video?
    !!youtube_video_id
  end

  def youtube_thumbnail_url
    id = youtube_video_id

    return nil if id.nil?

    # 320x180
    "https://img.youtube.com/vi/#{id}/mqdefault.jpg"
  end
end
