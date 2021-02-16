# frozen_string_literal: true

require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV['S3_BUCKET']
    config.aws_acl    = 'public-read'

    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    config.aws_attributes = lambda {
      {
        expires: 1.week.from_now.httpdate,
        cache_control: 'max-age=604800'
      }
    }

    config.aws_credentials = {
      access_key_id: ENV['S3_ACCESS_KEY'],
      secret_access_key: ENV['S3_SECRET_KEY'],
      region: ENV['S3_REGION'],
      stub_responses: Rails.env.test? # Optional, avoid hitting S3 actual during tests
    }
  end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:].\-+]/
