# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :load_playlists

  def check_signed_in
    return if user_signed_in?

    redirect_to new_user_session_url
  end

  private

  def load_playlists
    return unless user_signed_in?

    @playlists = current_user.playlist.all
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    return if email != 'guest@example.com'

    redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません'
  end
end
