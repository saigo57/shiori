# frozen_string_literal: true

class MediaTimeSpanController < ApplicationController
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

  # サインインしているか確認
  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end

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

  # 一つ前の状態に戻れる状態で、next_spansを適用する
  def forward_spans(next_spans)
    MediaTimeSpan.transaction do
      next_seq_id = @media_manage.curr_seq_id + 1
      prev_seq_id = @media_manage.curr_seq_id - 1

      import_list = next_spans.map do |span|
        @media_manage.time_spans.create({ seq_id: next_seq_id, **span })
      end

      MediaTimeSpan.import %w[begin_sec end_sec seq_id], import_list
      @media_manage.update(curr_seq_id: next_seq_id)
      @media_manage.media_time_span.where(seq_id: prev_seq_id).destroy_all
    end
  end

  # 重なっている時間をマージする
  def merge_spans(spans)
    sorted_spans = sort_spans(spans)
    merged_list = [sorted_spans.first]
    sorted_spans[1..].each do |span|
      if merged_list.last[:end_sec] < span[:begin_sec]
        merged_list.append(span)
      elsif merged_list.last[:end_sec] < span[:end_sec]
        merged_list.last[:end_sec] = span[:end_sec]
      end
    end
    merged_list
  end

  # spansをソート
  def sort_spans(spans)
    spans.sort do |a, b|
      if a[:begin_sec] == b[:begin_sec]
        a[:end_sec] <=> b[:end_sec]
      else
        a[:begin_sec] <=> b[:begin_sec]
      end
    end
  end
end
