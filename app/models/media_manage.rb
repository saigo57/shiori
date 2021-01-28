# frozen_string_literal: true

class MediaManage < ApplicationRecord
  include CommonModule
  belongs_to :user
  has_many :media_time_span, dependent: :destroy
  has_many :media_time_image, dependent: :destroy
  has_many :playlists, through: :playlist_media_manages
  has_many :playlist_media_manages, dependent: :destroy
  mount_uploader :thumbnail, ThumbnailUploader
  scope :join_curr_spans, lambda {
    eager_load(:media_time_span)
      .joins('AND media_time_spans.seq_id = media_manages.curr_seq_id')
  }
  scope :list, -> { join_curr_spans.preload(:media_time_image) }

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

  def remaining_seconds
    return nil if media_sec.nil?

    sec_watched = 0
    media_time_span.each do |s|
      sec_watched += [s.end_sec, media_sec].min - [s.begin_sec, media_sec].min if s.seq_id == curr_seq_id
    end

    media_sec - sec_watched
  end

  def media_status
    sec_remaining = remaining_seconds
    return '動画時間が登録されていません' if sec_remaining.nil?

    if media_time_span.any? && sec_remaining.positive?
      "視聴中・のこり#{sec_to_str(sec_remaining)}"
    elsif media_time_span.any? && sec_remaining <= 0
      '視聴済み'
    else
      '未視聴'
    end
  end

  def added_playlist?(playlist)
    @added_playlists ||= playlist_media_manages.pluck(:playlist_id)
    @added_playlists.include?(playlist.id)
  end
end
