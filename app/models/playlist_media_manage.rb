# frozen_string_literal: true

class PlaylistMediaManage < ApplicationRecord
  belongs_to :playlist
  belongs_to :media_manage
end
