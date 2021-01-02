# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'media_time_span', type: :request do
  let(:media_time_span) { create(:media_time_span) }
  let(:media_manage) { MediaManage.find(media_time_span.media_manage_id) }
  let(:user) { User.find(media_manage.user_id) }
  let(:media_manage2) { create(:media_manage2) }
  let(:user2) { User.find(media_manage2.user_id) }
  let(:param) do
    {
      media_manage_id: media_manage.id,
      begin_sec: 0,
      end_sec: 3600
    }
  end

  before do
    user.confirm
    user2.confirm
  end

  describe 'POST /media_time_span' do
    it 'media_manageの所有者でログインしている場合、POSTに成功しリダイレクトされること' do
      login(user)
      post media_time_span_index_path, params: param
      expect(response).to redirect_to media_manage_url(media_manage)
    end

    it 'media_manageの所有者以外でログインしている場合、POSTに失敗しrootにリダイレクトされること' do
      login(user2)
      post media_time_span_index_path, params: param
      expect(response).to redirect_to root_url
    end

    it '非ログイン時、loginページにリダイレクトされること' do
      post media_time_span_index_path, params: param
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'DELETE /media_time_span' do
    it 'media_manageの所有者でログインしている場合、削除に成功しリダイレクトされること' do
      login(user)
      delete media_time_span_path(media_time_span), params: { id: media_time_span.id }
      expect(response).to redirect_to media_manage_url(media_manage)
    end

    it 'media_manageの所有者以外でログインしている場合、POSTに失敗しrootにリダイレクトされること' do
      login(user2)
      delete media_time_span_path(media_time_span), params: { id: media_time_span.id }
      expect(response).to redirect_to root_url
    end

    it '非ログイン時、loginページにリダイレクトされること' do
      delete media_time_span_path(media_time_span), params: { id: media_time_span.id }
      expect(response).to redirect_to new_user_session_url
    end
  end
end
