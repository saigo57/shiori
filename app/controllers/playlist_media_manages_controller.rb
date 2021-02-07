# frozen_string_literal: true

class PlaylistMediaManagesController < ApplicationController
  before_action :check_signed_in
  before_action :load_params, only: [:create, :destroy]
  before_action :load_playlist, only: [:create, :destroy]

  def create
    @playlist.playlist_media_manages.create(
      playlist_id: @param_playlist_id,
      media_manage_id: @param_media_manage_id
    )
    @playlist_media_manage = @playlist.playlist_media_manages.find_by(
      media_manage_id: @media_manage.id
    )
  end

  def destroy
    @playlist.playlist_media_manages.find_by(
      playlist_id: @param_playlist_id,
      media_manage_id: @param_media_manage_id
    )&.destroy
    @playlist_media_manage = PlaylistMediaManage.new
  end

  private

  def load_params
    @param_playlist_id = params[:playlist_media_manage][:playlist_id].to_i
    @param_media_manage_id = params[:playlist_media_manage][:media_manage_id].to_i
  rescue NoMethodError
    render json: {}, status: :bad_request
  end

  def load_playlist
    @playlist = current_user.playlist.find_by(id: @param_playlist_id)
    @media_manage = current_user.media_manage.find_by(id: @param_media_manage_id)

    render json: {}, status: :bad_request if @playlist.nil? || @media_manage.nil?
  end
end
