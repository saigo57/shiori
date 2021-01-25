# frozen_string_literal: true

class PlaylistMediaManagesController < ApplicationController
  before_action :load_playlist, only: [:create, :destroy]

  def create
    @playlist.playlist_media_manages.create(
      playlist_id: params[:playlist_media_manage][:playlist_id].to_i,
      media_manage_id: params[:playlist_media_manage][:media_manage_id].to_i
    )
    @playlist_media_manage = @playlist.playlist_media_manages.find_by(
      media_manage_id: @media_manage.id
    )
  end

  def destroy
    @playlist.playlist_media_manages.find_by(
      playlist_id: params[:playlist_media_manage][:playlist_id].to_i,
      media_manage_id: params[:playlist_media_manage][:media_manage_id].to_i
    )&.destroy
    @playlist_media_manage = PlaylistMediaManage.new
  end

  private

  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end

  def load_playlist
    @playlist = current_user.playlist.find_by(
      id: params[:playlist_media_manage][:playlist_id].to_i
    )
    @media_manage = current_user.media_manage.find_by(id: params[:playlist_media_manage][:media_manage_id].to_i)
  end
end
