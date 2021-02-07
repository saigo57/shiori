# frozen_string_literal: true

module ReflectYoutube
  extend ActiveSupport::Concern
  include YoutubeUtils

  # youtubeのmediaであれば、youtubeから情報を取得する
  def try_update_youtube(media_manage)
    @media_manage = media_manage
    return unless @media_manage.youtube_video?

    info = fetch_youtube_video_info(@media_manage.youtube_video_id)
    logger.info("youtube info[#{info}]")

    update_youtube(info)
  rescue YoutubeUtils::YoutubeFetchError => e
    logger.error("youtube fetch error. #{e}")
    flash[:warn] = 'youtubeからの取得に失敗しました。'
  end

  # youtubeから取得した情報でUPDATEする
  def update_youtube(info)
    if @media_manage.update(info)
      flash[:info] = 'youtubeからの取得に成功しました。'
    else
      flash[:warn] = 'youtube情報の保存に失敗しました。'
    end
  end
end
