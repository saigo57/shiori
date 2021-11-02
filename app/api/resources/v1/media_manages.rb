# frozen_string_literal: true

module Resources
  module V1
    class MediaManages < Grape::API
      resource :media_manages do
        helpers do
          include ReflectYoutube
        end

        # GET /api/v1/media_manages?media_url=
        desc '動画情報取得'
        params do
          requires :media_url, type: String, desc: 'media_url'
        end
        get do
          authenticate_user!
          # URL変形
          m = MediaManage.new.tap do |obj|
            obj.media_url = params[:media_url]
          end

          media_manage = current_user.media_manage.find_by(media_url: m.media_url)
          return { id: nil, status: '未登録' } unless media_manage

          {
            id: media_manage.id,
            status: media_manage.media_status
          }
        end

        # POST /api/v1/media_manages/
        desc '動画新規登録'
        params do
          requires :media_url, type: String, desc: 'media_url'
        end
        post do
          authenticate_user!
          media_manage = current_user.media_manage.create(media_url: params[:media_url])
          media_manage.save
          try_update_youtube(media_manage)
        end
      end
    end
  end
end
