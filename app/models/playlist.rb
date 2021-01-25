# frozen_string_literal: true

class Playlist < ApplicationRecord
  belongs_to :user
  has_many :media_manages, through: :playlist_media_manages
  has_many :playlist_media_manages, dependent: :destroy
end
