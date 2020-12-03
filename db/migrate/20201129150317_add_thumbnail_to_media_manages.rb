# frozen_string_literal: true

class AddThumbnailToMediaManages < ActiveRecord::Migration[6.0]
  def change
    add_column :media_manages, :thumbnail, :string
  end
end
