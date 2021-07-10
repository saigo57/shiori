# frozen_string_literal: true

class FinishWatchingsController < ApplicationController
  include MediaTimeSpanTool
  before_action :check_signed_in

  def create
    @media_manage = current_user.media_manage.find(params[:media_manage_id])
    if @media_manage.media_sec_exists?
      forward_spans([{ begin_sec: 0, end_sec: @media_manage.media_sec }])
    else
      flash[:error] = '動画時間がない場合は視聴完了にできません。'
    end

    redirect_to media_manage_url(@media_manage)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end
end
