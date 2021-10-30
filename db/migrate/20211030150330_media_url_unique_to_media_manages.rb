# frozen_string_literal: true

class MediaUrlUniqueToMediaManages < ActiveRecord::Migration[6.1]
  def change
    add_index :media_manages, [:user_id, :media_url], unique: true
  end
end
