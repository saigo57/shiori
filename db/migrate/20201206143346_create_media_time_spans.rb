# frozen_string_literal: true

class CreateMediaTimeSpans < ActiveRecord::Migration[6.0]
  def change
    create_table :media_time_spans do |t|
      t.integer :begin_sec
      t.integer :end_sec
      t.belongs_to :media_manage

      t.timestamps
    end
  end
end
