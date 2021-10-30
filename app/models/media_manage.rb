# frozen_string_literal: true

class MediaManage < ApplicationRecord
  include CommonModule
  belongs_to :user
  has_many :media_time_span, dependent: :destroy
  has_many :media_time_image, dependent: :destroy
  has_many :playlists, through: :playlist_media_manages
  has_many :playlist_media_manages, dependent: :destroy
  validates :media_url, length: { minimum: 1 }, allow_nil: true
  validates :media_url, uniqueness: { scope: :user }, allow_nil: true
  mount_uploader :thumbnail, ThumbnailUploader
  enum status: { unknown: 0, nowatch: 1, watching: 2, watched: 3, do_not_watch: 4 }
  scope :join_curr_spans, lambda {
    eager_load(:media_time_span)
      .joins('AND media_time_spans.seq_id = media_manages.curr_seq_id')
  }
  scope :list, -> { join_curr_spans.preload(:media_time_image) }
  scope :search, SearchMediaManageQuery

  before_update :denormalize_mark
  before_create :denormalize_mark
  before_commit :update_denormalized
  attr_accessor :span_changed

  after_initialize do
    self.span_changed = false
  end

  def media_url=(val)
    if (youtube_id = extract_youtube_id(val))
      val = build_youtube_url(youtube_id)
    end

    self[:media_url] = val
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

    extract_youtube_id(media_url)
  end

  def youtube_video?
    !!youtube_video_id
  end

  def do_not_watch?
    status == 'do_not_watch'
  end

  def set_do_not_watch
    update(status: 'do_not_watch')
  end

  def cancel_do_not_watch
    # 適当なstatusにしてstatusの非正規化を発火させる
    update(status: 'unknown')
  end

  def media_url_with_sec(sec)
    media_url unless youtube_video?

    build_youtube_url(youtube_video_id, sec)
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

    @sec_watched = 0
    curr_media_time_spans.each do |s|
      @sec_watched += [s.end_sec, media_sec].min - [s.begin_sec, media_sec].min if s.seq_id == curr_seq_id
    end
    @sec_watched
  end

  def media_sec_exists?
    !media_sec.nil? && !media_sec.zero?
  end

  def choice_status
    return :do_not_watch if do_not_watch?
    # 動画時間がない場合は計算できないのでunknown
    return :unknown unless media_sec_exists?
    # 視聴時間0のときは未視聴
    return :nowatch if watched_seconds.zero?
    # のこり時間が1以上のときは視聴中
    return :watching if remaining_sec.positive?

    # 視聴済み
    :watched
  end

  def media_status
    case status
    when 'watching'
      "視聴中・のこり#{sec_to_str(remaining_sec)}"
    when 'watched'
      '視聴済み'
    when 'nowatch'
      '未視聴'
    when 'unknown'
      '動画時間が登録されていません'
    when 'do_not_watch'
      '今は見ない'
    else
      '異常'
    end
  end

  def added_playlist?(playlist)
    @added_playlists ||= playlist_media_manages.pluck(:playlist_id)
    @added_playlists.include?(playlist.id)
  end

  def denormalize_mark
    @denormalize = true
  end

  # 非正規化したカラムを更新する
  def update_denormalized
    return if destroyed?
    return unless @denormalize || span_changed

    self.remaining_sec = media_sec - watched_seconds unless media_sec.nil?
    self.status = choice_status
    self.span_changed = false
    @denormalize = false
    save!
  end
end
