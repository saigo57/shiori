# frozen_string_literal: true

class CreateMediaManages < ActiveRecord::Migration[6.0]
  def change
    create_table :media_manages do |t|
      t.string :title
      t.belongs_to :user

      t.timestamps
    end
  end
end
