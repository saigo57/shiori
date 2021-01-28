# frozen_string_literal: true

class ChangeReferenceToBlongsTo < ActiveRecord::Migration[6.0]
  def change
    remove_reference :playlists, :user, index: true
    remove_reference :playlist_media_manages, :playlist, index: true
    remove_reference :playlist_media_manages, :media_manage, index: true

    add_column :playlists, :user_id, :bigint

    change_table :playlist_media_manages, bulk: true do |t|
      t.belongs_to :playlist
      t.belongs_to :media_manage
    end
  end
end
