# frozen_string_literal: true

module MediaManagesHelper
  def thumbnail_tag(media_manage, size = '320x180', html_class = '')
    url = if !media_manage.youtube_thumbnail_url.nil?
            media_manage.youtube_thumbnail_url
          elsif media_manage.thumbnail?
            media_manage.thumbnail.url
          else
            'no-image.jpg'
          end

    image_tag url, size: size, class: html_class
  end
end
