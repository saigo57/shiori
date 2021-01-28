# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists', type: :request do
  let!(:media_manage) { create(:media_manage) }
  let!(:user) { media_manage.user }
  let!(:playlist) { create(:playlist, user: user) }
  let!(:playlist2) { create(:playlist2) }
  let!(:playlist_media_manage) do
    create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
  end

  before do
    user.confirm
  end

  describe 'GET /playlist/new' do
    it '非ログイン時、loginページにリダイレクトすること' do
      get new_playlist_path
      expect(response).to redirect_to new_user_session_url
    end

    it 'ログイン時、アクセスに成功し、新たにできたプレイリストのページにリダイレクトすること' do
      login(user)
      next_id = Playlist.maximum(:id).next
      get new_playlist_path
      expect(response).to redirect_to playlist_url(next_id)
    end
  end

  describe 'GET /playlists/[id]' do
    it '非ログイン時はloginページにリダイレクトされること' do
      get playlist_path(playlist)
      expect(response).to redirect_to new_user_session_url
    end

    it '自分のplaylistの場合、表示に成功すること' do
      login(user)
      get playlist_path(playlist)
      expect(response).to have_http_status(200)
      expect(response.body).to include 'テストプレイリスト'
    end

    it '自分のplaylistではない場合、homeにリダイレクトすること' do
      login(user)
      get playlist_path(playlist2)
      expect(response).to redirect_to root_url
    end
  end

  describe 'PATCH /playlists/[id]' do
    let(:param) do
      {
        id: playlist.id,
        playlist: {
          name: 'newプレイリストname'
        }
      }
    end

    it '非ログインの場合、rootページにリダイレクトすること' do
      patch playlist_path(playlist), params: param
      expect(response).to redirect_to new_user_session_url
    end

    it '自分のplaylistの場合、更新に成功すること' do
      login(user)
      patch playlist_path(playlist), params: param
      expect(response).to redirect_to playlist_path(playlist)
    end

    it '自分のplaylistではない場合、rootページにリダイレクトすること' do
      login(user)
      patch playlist_path(playlist2), params: param
      expect(response).to redirect_to root_url
    end
  end

  describe 'DELETE /playlist/[id]' do
    it '非ログインの場合、loginページにリダイレクトすること' do
      delete playlist_path(playlist)
      expect(response).to redirect_to new_user_session_url
    end

    it '自分のplaylistの場合、削除に成功しhomeにリダイレクトすること' do
      login(user)
      delete playlist_path(playlist)
      expect(response).to redirect_to root_url
    end

    it '自分のplaylistではない場合、rootページにリダイレクトすること' do
      login(user)
      delete playlist_path(playlist)
      expect(response).to redirect_to root_url
    end
  end
end
