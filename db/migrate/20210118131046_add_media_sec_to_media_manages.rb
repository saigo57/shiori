# frozen_string_literal: true

class AddMediaSecToMediaManages < ActiveRecord::Migration[6.0]
  def change
    add_column :media_manages, :media_sec, :integer
  end
end
