# frozen_string_literal: true

module Resources
  module V1
    class MediaManages < Grape::API
      resource :media_manages do
        helpers do
          include ReflectYoutube
        end

        # POST /api/v1/media_manages/
        desc 'user list'
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
