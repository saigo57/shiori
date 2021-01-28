# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlaylistMediaManages', type: :request do
  let!(:media_manage) { create(:media_manage) }
  let!(:user) { media_manage.user }
  let!(:playlist) { create(:playlist, user: user) }

  let!(:media_manage2) { create(:media_manage2) }
  let!(:user2) { media_manage2.user }
  let!(:playlist2) { create(:playlist2, user: user2) }

  # 非ログイン時はCSRFエラーとなるためここではテストしない
  before do
    user.confirm
    login(user)
  end

  def build_param(playlist_id, media_manage_id)
    {
      playlist_media_manage: {
        playlist_id: playlist_id,
        media_manage_id: media_manage_id
      }
    }
  end

  describe 'POST /playlists' do
    it 'playlist, media_manage共に自分のものだった場合、アクセスに成功すること' do
      param = build_param(playlist.id, media_manage.id)
      post playlist_media_manages_path, params: param, xhr: true
      expect(response.response_code).to eq 200
    end

    it 'playlistが自分のものではない場合、アクセスに失敗すること' do
      param = build_param(playlist2.id, media_manage.id)
      post playlist_media_manages_path, params: param, xhr: true
      expect(response.response_code).to eq 400
    end

    it 'media_manageが自分のものではない場合、アクセスに失敗すること' do
      param = build_param(playlist.id, media_manage2.id)
      post playlist_media_manages_path, params: param, xhr: true
      expect(response.response_code).to eq 400
    end

    it 'パラメータに数値以外が渡されたとき、アクセスに失敗すること' do
      param = build_param('playlist.id', 'media_manage.id')
      post playlist_media_manages_path, params: param, xhr: true
      expect(response.response_code).to eq 400
    end

    it 'パラメータが不完全な場合、アクセスに失敗すること' do
      param = {
        playlist_media_manage: {
        }
      }
      post playlist_media_manages_path, params: param, xhr: true
      expect(response.response_code).to eq 400
    end
  end

  describe 'DELETE /playlists' do
    let(:playlist_media_manage) do
      create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
    end

    it 'playlist, media_manage共に自分のものだった場合、アクセスに成功すること' do
      param = build_param(playlist.id, media_manage.id)
      delete playlist_media_manage_path(playlist_media_manage.id), params: param, xhr: true
      expect(response.response_code).to eq 200
    end

    it 'playlistが自分のものではない場合、アクセスに失敗すること' do
      param = build_param(playlist2.id, media_manage.id)
      delete playlist_media_manage_path(playlist_media_manage.id), params: param, xhr: true
      expect(response.response_code).to eq 400
    end

    it 'media_manageが自分のものではない場合、アクセスに失敗すること' do
      param = build_param(playlist.id, media_manage2.id)
      delete playlist_media_manage_path(playlist_media_manage.id), params: param, xhr: true
      expect(response.response_code).to eq 400
    end
  end
end
