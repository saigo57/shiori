# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FinishWatchings', type: :request do
  let(:media_time_span) { create(:media_time_span) }
  let(:media_manage) { MediaManage.find(media_time_span.media_manage_id) }
  let(:user) { User.find(media_manage.user_id) }
  let(:media_manage2) { create(:media_manage2) }
  let(:user2) { User.find(media_manage2.user_id) }

  before do
    user.confirm
    user2.confirm
  end

  describe 'POST /finish_watching' do
    it 'media_manageの所有者でログインしている場合、削除に成功しリダイレクトされること' do
      login(user)
      post finish_watching_path, params: { media_manage_id: media_manage.id }
      expect(response).to redirect_to media_manage_url(media_manage)
    end

    it 'media_manageの所有者以外でログインしている場合、POSTに失敗しrootにリダイレクトされること' do
      login(user2)
      post finish_watching_path, params: { media_manage_id: media_manage.id }
      expect(response).to redirect_to root_url
    end

    it '非ログイン時、loginページにリダイレクトされること' do
      post finish_watching_path, params: { media_manage_id: media_manage.id }
      expect(response).to redirect_to new_user_session_url
    end
  end
end
