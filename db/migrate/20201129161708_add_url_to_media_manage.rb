# frozen_string_literal: true

class AddUrlToMediaManage < ActiveRecord::Migration[6.0]
  def change
    add_column :media_manages, :media_url, :string
  end
end
