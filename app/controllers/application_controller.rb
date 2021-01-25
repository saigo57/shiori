# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :load_playlists

  private

  def load_playlists
    return unless user_signed_in?

    @playlists = current_user.playlist.all
  end
end
