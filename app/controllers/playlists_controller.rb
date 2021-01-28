# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :check_signed_in
  before_action :load_playlist, only: [:show, :update, :destroy]

  def new
    playlist = current_user.playlist.create(name: '新規プレイリスト')
    playlist.save
    redirect_to playlist
  end

  def show
    @media_manages = current_user.media_manage.eager_load(:playlist_media_manages)
                                 .where(playlist_media_manages: { playlist_id: @playlist.id })
  end

  def update
    if @playlist.update(playlist_params)
      flash[:success] = 'プレイリスト情報を更新しました'
      redirect_to @playlist
    else
      render 'show'
    end
  end

  def destroy
    if @playlist.destroy
      flash[:success] = "#{@playlist.name}を削除しました"
    else
      flash[:error] = 'プレイリストの削除に失敗しました'
    end

    redirect_to root_url
  end

  private

  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end

  def playlist_params
    params.require(:playlist).permit(:name)
  end

  def load_playlist
    @playlist = current_user.playlist.find_by(id: params[:id])

    return unless @playlist.nil?

    flash[:error] = 'このURLは存在しません'
    redirect_to root_url
  end
end
