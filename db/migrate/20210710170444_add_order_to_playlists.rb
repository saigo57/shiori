# frozen_string_literal: true

class AddOrderToPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :order, :integer
  end
end
