# frozen_string_literal: true

class MediaTimeImageUploaderUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process convert: 'jpg'
  version :thumb do
    process resize_to_fit: [320, 180]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def filename
    return if original_filename.blank?

    time = Time.zone.now
    name = "#{time.strftime('%Y%m%d%H%M%S')}.jpg"
    name.downcase
  end
end
