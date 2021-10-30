# frozen_string_literal: true

module Resources
  module V1
    class Root < Grape::API
      version 'v1'
      format :json
      content_type :json, 'application/json'

      helpers do
        def session
          env['rack.session']
        end

        def authenticate_error!
          # 認証が失敗したときのエラー
          h = {
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Request-Method' => %w[GET POST OPTIONS].join(',')
          }
          error!('You need to log in to use the app.', 401, h)
        end

        def user_signed_in?
          !!current_user
        end

        def current_user
          env['warden'].user
        end

        def authenticate_user!
          return if user_signed_in?

          authenticate_error!
        end
      end

      mount Resources::V1::MediaManages
    end
  end
end
