# frozen_string_literal: true

module ReflectYoutube
  extend ActiveSupport::Concern
  include YoutubeUtils

  def output_message(level, message)
    flash[level] = message if defined? flash
  end

  # youtubeのmediaであれば、youtubeから情報を取得する
  def try_update_youtube(media_manage)
    @media_manage = media_manage
    return unless @media_manage.youtube_video?

    info = fetch_youtube_video_info(@media_manage.youtube_video_id)
    Rails.logger.info("youtube info[#{info}]")

    update_youtube(info)
  rescue YoutubeUtils::YoutubeFetchError => e
    Rails.logger.error("youtube fetch error. #{e}")
    output_message(:warn, 'youtubeからの取得に失敗しました。')
  end

  # youtubeから取得した情報でUPDATEする
  def update_youtube(info)
    if @media_manage.update(info)
      output_message(:info, 'youtubeからの取得に成功しました。')
    else
      output_message(:warn, 'youtube情報の保存に失敗しました。')
    end
  end
end
