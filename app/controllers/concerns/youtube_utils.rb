# frozen_string_literal: true

module YoutubeUtils
  extend ActiveSupport::Concern

  class YoutubeFetchError < StandardError
    def initialize(msg = '')
      super
    end
  end

  def fetch_youtube_video_info(id)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['YOUTUBE_DATA_API_KEY']
    options = { id: id }
    details = service.list_videos(:contentDetails, options)
    snippet = service.list_videos(:snippet, options)
    raise YoutubeFetchError, 'details.items.length error' if details.items.length != 1
    raise YoutubeFetchError, 'snippet.items.length error' if snippet.items.length != 1

    format_video_info(details, snippet)
  rescue Google::Apis::ServerError,
         Google::Apis::ClientError,
         Google::Apis::AuthorizationError => e
    raise YoutubeFetchError, "google api error #{e.message}"
  end

  private

  def format_video_info(details, snippet)
    duration_iso = details.items[0].content_details.duration
    duration = ActiveSupport::Duration.parse(duration_iso)

    {
      media_sec: duration.seconds,
      title: snippet.items[0].snippet.title
    }
  end
end
