# frozen_string_literal: true

class MediaManagesController < ApplicationController
  include MediaManagesHelper
  include ReflectYoutube
  before_action :check_signed_in
  before_action :load_params,       only: [:index]
  before_action :load_media_manage, only: [:edit, :show, :update, :destroy, :restore,
                                           :fetch, :do_not_watch, :cancel_do_not_watch]
  before_action :load_playlist,     only: [:edit, :show, :update, :restore, :fetch]
  before_action :check_can_restore, only: [:restore]

  NEW_TITLE = '新規'
  DEFAULT_SEARCH_FLAGS = { unknown: true, watching: true, watched: false, nowatch: true, do_not_watch: false }.freeze
  SORT_ITEMS = { '登録順': 'registration', '残り動画時間': 'remaining_time', '動画時間': 'media_time' }.freeze
  DEFAULT_SORT_TARGET = 'registration'

  def index
    @media_manages = current_user.media_manage.search(
      @search_flags, @sort_target, @sort_order, @keywords_text
    ).page(params[:page]).per(20)
    @sort_items = SORT_ITEMS
  end

  def new
    # 新規登録formは用意せず、modelを作ってeditに飛ばす
    media_manage = current_user.media_manage.create(title: NEW_TITLE)
    media_manage.save
    redirect_to edit_media_manage_path(media_manage)
  end

  def edit; end

  def show
    @time_spans = @media_manage.time_spans
    @media_time_image = MediaTimeImage.new

    # PlaylistからPlaylistMediaManageへのハッシュを作成
    @pm_hash = {}
    @playlists.each do |p|
      @pm_hash[p.id] = PlaylistMediaManage.new
    end

    @media_manage.playlist_media_manages.each do |r|
      @pm_hash[r.playlist_id] = r
    end
  end

  def update
    if @media_manage.update(media_manage_params)
      flash[:success] = '動画情報を更新しました'
      try_update_youtube(@media_manage)
      redirect_to_media_manage(@media_manage)
    else
      if @media_manage.errors[:media_url].any?
        if @media_manage.media_url.present?
          @duplicate_media_manage = current_user.media_manage.find_by(media_url: @media_manage.media_url)
        else
          flash[:error] = 'URLは空にできません。'
        end
      end
      render 'edit'
    end
  end

  def destroy
    flash[:success] = '動画情報を削除しました'
    @media_manage.destroy
    redirect_to media_manages_url
  end

  def restore
    MediaTimeSpan.transaction do
      curr_seq_id = @media_manage.curr_seq_id
      prev_seq_id = @media_manage.curr_seq_id - 1
      @media_manage.update(curr_seq_id: prev_seq_id)
      @media_manage.media_time_span.where(seq_id: curr_seq_id).destroy_all
    end

    flash[:success] = '元に戻しました'
    redirect_to_media_manage(@media_manage)
  end

  def fetch
    try_update_youtube(@media_manage)
    redirect_to_media_manage(@media_manage)
  end

  def do_not_watch
    @media_manage.set_do_not_watch
    redirect_to_media_manage(@media_manage)
  end

  def cancel_do_not_watch
    @media_manage.cancel_do_not_watch
    redirect_to_media_manage(@media_manage)
  end

  private

  def load_playlist
    @playlist_param = playlist_param
    @inflow_playlist = Playlist.find(params[:playlist]) if params[:playlist]
  end

  def check_can_restore
    return if @media_manage.can_restore

    flash[:error] = '戻すバージョンがありません'
    redirect_to_media_manage(@media_manage)
  end

  def load_media_manage
    @media_manage = current_user.media_manage.find_by(id: params[:id])

    return unless @media_manage.nil?

    flash[:error] = 'このURLは存在しません'
    Rails.logger.info { "media_manage could not found id:#{params[:id]}" }
    redirect_to root_url
  end

  def load_params
    @keywords_text = params.include?('keywords') ? params['keywords'] : ''
    sort_target_valid = params.include?('sort_target') && !params['sort_target'].empty?
    @sort_target = sort_target_valid ? params['sort_target'] : DEFAULT_SORT_TARGET
    @sort_order = param_order
    @search_flags = param_flags
  end

  def param_order
    order_list = %w[asc desc]
    default_order = :asc
    return default_order unless params.include?('sort_order')
    return default_order if params['sort_order'].empty?
    return default_order unless order_list.include?(params['sort_order'])

    params['sort_order'].to_sym
  end

  def param_flags
    DEFAULT_SEARCH_FLAGS.keys.map do |key|
      if params.include?(key)
        [key, params[key] == '1']
      else
        [key, DEFAULT_SEARCH_FLAGS[key]]
      end
    end.to_h
  end

  def media_manage_params
    params.require(:media_manage).permit(:title, :thumbnail, :media_url, :media_sec)
  end
end
