# frozen_string_literal: true

class StatusToMediaManage < ActiveRecord::Migration[6.0]
  def change
    change_table :media_manages do |t|
      t.integer :status, default: 0
    end
  end
end
