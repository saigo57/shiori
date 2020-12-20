# frozen_string_literal: true

class MediaManagesController < ApplicationController
  include MediaManagesHelper
  before_action :check_signed_in
  before_action :media_manage, only: [:edit, :show, :update, :destroy, :restore]
  before_action :check_can_restore, only: [:restore]

  def index
    @media_manages = current_user.media_manage
  end

  def new
    # 新規登録formは用意せず、modelを作ってeditに飛ばす
    media_manage = current_user.media_manage.create(title: '新規')
    media_manage.save
    redirect_to edit_media_manage_path(media_manage)
  end

  def edit; end

  def show
    @time_spans = @media_manage.time_spans
  end

  def update
    if @media_manage.update(media_manage_params)
      flash[:success] = '動画情報を更新しました'
      redirect_to @media_manage
    else
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
    redirect_to @media_manage
  end

  private

  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end

  def check_can_restore
    return if @media_manage.can_restore

    flash[:error] = '戻すバージョンがありません'
    redirect_to @media_manage
  end

  def media_manage_params
    params.require(:media_manage).permit(:title, :thumbnail, :media_url)
  end

  def media_manage
    @media_manage = current_user.media_manage.find_by(id: params[:id])

    return unless @media_manage.nil?

    flash[:error] = 'このURLは存在しません'
    redirect_to root_url
  end
end
