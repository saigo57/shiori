# frozen_string_literal: true

class CreatePlaylistMediaManages < ActiveRecord::Migration[6.0]
  def change
    create_table :playlist_media_manages do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :media_manage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
