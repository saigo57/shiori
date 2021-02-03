# frozen_string_literal: true

class MediaManage < ApplicationRecord
  include CommonModule
  belongs_to :user
  has_many :media_time_span, dependent: :destroy
  has_many :media_time_image, dependent: :destroy
  has_many :playlists, through: :playlist_media_manages
  has_many :playlist_media_manages, dependent: :destroy
  mount_uploader :thumbnail, ThumbnailUploader
  enum status: { unknown: 0, nowatch: 1, watching: 2, watched: 3 }
  scope :join_curr_spans, lambda {
    eager_load(:media_time_span)
      .joins('AND media_time_spans.seq_id = media_manages.curr_seq_id')
  }
  scope :list, -> { join_curr_spans.preload(:media_time_image) }
  scope :search_text, lambda { |keywords|
    pattern = ''
    keywords.each do |keyword|
      pattern += "(?=.*#{keyword})"
    end
    pattern += '.*'

    l = list
    l.where('media_manages.title REGEXP ?', pattern)
     .or(l.where('media_manages.media_url REGEXP ?', pattern))
  }
  scope :search2, lambda { |flags, keywords = nil|
    base_list = if keywords.nil?
                  list
                else
                  search_text(keywords)
                end

    status_list = []
    [:nowatch, :watching, :watched, :unknown].each do |item|
      status_list.append(statuses[item]) if flags[item]
    end

    base_list.where(status: status_list)
  }
  scope :search, lambda { |flags, sort_target, sort_order, keywords = nil|
    base_scope = search2(flags, keywords)
    order = if sort_order == 0
              :asc
            else
              :desc
            end
    if sort_target == 'media_time'
      base_scope.order(media_sec: order)
    elsif sort_target == 'remaining_time'
      base_scope.order(remaining_sec: order)
    else
      base_scope
    end
  }

  before_commit :update_denormalized
  attr_accessor :span_changed

  after_initialize do
    self.span_changed = false
  end

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

  def curr_media_time_spans
    media_time_span.where(seq_id: curr_seq_id)
  end

  def watched_seconds
    return nil if media_sec.nil?
    return @sec_watched unless @sec_watched.nil?

    @sec_watched = 0
    curr_media_time_spans.each do |s|
      @sec_watched += [s.end_sec, media_sec].min - [s.begin_sec, media_sec].min if s.seq_id == curr_seq_id
    end
    @sec_watched
  end

  def media_status
    return '動画時間が登録されていません' if remaining_sec.nil?

    case status
    when 'watching'
      "視聴中・のこり#{sec_to_str(remaining_sec)}"
    when 'watched'
      '視聴済み'
    when 'nowatch'
      '未視聴'
    when 'unknown'
      '動画時間が登録されていません'
    else
      '異常'
    end
  end

  def added_playlist?(playlist)
    @added_playlists ||= playlist_media_manages.pluck(:playlist_id)
    @added_playlists.include?(playlist.id)
  end

  # 非正規化したカラムを更新する
  def update_denormalized
    return if destroyed?
    return unless span_changed

    self.remaining_sec = media_sec - watched_seconds unless media_sec.nil?
    has_watched = watched_seconds&.positive?

    self.status = if remaining_sec.nil?
                    :unknown
                  elsif has_watched && remaining_sec.positive?
                    :watching
                  elsif has_watched && remaining_sec <= 0
                    :watched
                  else
                    :nowatch
                  end

    self.span_changed = false
    save!
  end
end
