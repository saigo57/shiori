# frozen_string_literal: true

class CreateMediaTimeImages < ActiveRecord::Migration[6.0]
  def change
    create_table :media_time_images do |t|
      t.string :image
      t.belongs_to :media_manage

      t.timestamps
    end
  end
end
