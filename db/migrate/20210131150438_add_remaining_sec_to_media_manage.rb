# frozen_string_literal: true

class AddRemainingSecToMediaManage < ActiveRecord::Migration[6.0]
  def change
    change_table :media_manages do |t|
      t.integer :remaining_sec
    end
  end
end
