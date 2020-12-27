# frozen_string_literal: true

class MediaTimeImage < ApplicationRecord
  belongs_to :media_manage
  mount_uploader :image, MediaTimeImageUploaderUploader
end
