# frozen_string_literal: true

class MediaTimeSpanController < ApplicationController
  before_action :check_signed_in

  def new
    media_manage = current_user.media_manage.find_by(id: params[:media_manage_id])
    begin_sec = params[:begin_sec]
    end_sec = params[:end_sec]
    media_time_span = media_manage.media_time_span.create(begin_sec: begin_sec, end_sec: end_sec)
    media_time_span.save
    redirect_to media_manage_url(media_manage)
  end

  private

  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end
end
