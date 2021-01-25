# frozen_string_literal: true

class AddUserIdToPlaylist < ActiveRecord::Migration[6.0]
  def change
    add_reference :playlists, :user, foreign_key: true
  end
end
