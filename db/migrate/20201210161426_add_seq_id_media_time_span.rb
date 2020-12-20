# frozen_string_literal: true

class AddSeqIdMediaTimeSpan < ActiveRecord::Migration[6.0]
  def change
    add_column :media_time_spans, :seq_id, :integer, default: 1, null: false
    add_column :media_manages, :curr_seq_id, :integer, default: 1, null: false
  end
end
