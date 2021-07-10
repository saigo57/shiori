# frozen_string_literal: true

class MediaTimeSpanController < ApplicationController
  include MediaTimeSpanTool
  before_action :check_signed_in
  before_action :find_media_manage, only: :create
  before_action :find_media_time_span, only: :destroy
  before_action :validate_span_param, only: :create

  def create
    curr_spans = current_spans
    curr_spans << param_span_hash

    next_spans = merge_spans(curr_spans)
    forward_spans(next_spans)

    redirect_to media_manage_url(@media_manage)
  end

  def destroy
    @media_time_span.destroy
    flash[:success] = '時間を削除しました'
    redirect_to media_manage_url(@media_manage)
  end

  private

  # paramsをもとにmedia_manageを取得
  def find_media_manage
    @media_manage = current_user.media_manage.find(params[:media_manage_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end

  # paramsをもとにmedia_time_span, media_manageを取得
  # media_manageがログインユーザーのものでない場合はroot_urlに飛ばす
  def find_media_time_span
    @media_time_span = MediaTimeSpan.find(params[:id])
    @media_manage = @media_time_span.media_manage
    redirect_to root_url unless @media_manage.user_id == current_user.id
  end

  # paramsのbegin_secとend_secのvalidation
  def validate_span_param
    begin_sec = params[:begin_sec].to_i
    end_sec = params[:end_sec].to_i

    return if begin_sec < end_sec

    flash[:error] = '開始時間より終了時間を大きくしてください'
    redirect_to media_manage_url(@media_manage)
  end

  # paramのspanを整数として返す
  def param_span_hash
    begin_sec = params[:begin_sec].to_i
    end_sec = params[:end_sec].to_i

    { begin_sec: begin_sec, end_sec: end_sec }
  end

  # 現在のspanリストを返す
  def current_spans
    span_array = []
    @media_manage.time_spans.each do |time_span|
      span_array << {
        begin_sec: time_span.begin_sec,
        end_sec: time_span.end_sec
      }
    end
    span_array
  end
end
