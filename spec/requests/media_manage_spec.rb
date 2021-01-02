# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'media_manage', type: :request do
  let(:media_manage) { create(:media_manage) }
  let(:media_manage2) { create(:media_manage2) }
  let(:user) { User.find(media_manage.user_id) }
  let(:user2) { User.find(media_manage2.user_id) }

  before do
    user.confirm
    user2.confirm
  end

  describe 'GET /media_manages' do
    it '非ログイン時はloginページにリダイレクトされること' do
      get media_manages_path
      expect(response).to redirect_to new_user_session_url
    end

    it 'ログイン時はアクセスに成功すること' do
      login(user)
      get media_manages_path
      expect(response).to have_http_status(200)
      expect(response.body).to include 'media_manageタイトル'
    end

    context 'ログインしているユーザーの情報のみ表示されること' do
      it 'userでログインしたとき' do
        login(user)
        get media_manages_path
        expect(response).to have_http_status(200)
        expect(response.body).to include 'media_manageタイトル'
        expect(response.body).to_not include 'media_manage_title'
      end

      it 'user2でログインしたとき' do
        login(user2)
        get media_manages_path
        expect(response).to have_http_status(200)
        expect(response.body).to_not include 'media_manageタイトル'
        expect(response.body).to include 'media_manage_title'
      end
    end
  end

  describe 'GET /media_manages/[id]' do
    it '自分のmedia_manageの場合、表示に成功すること' do
      login(user)
      get media_manage_path(media_manage)
      expect(response).to have_http_status(200)
      expect(response.body).to include 'media_manageタイトル'
    end

    it '自分のmedia_manageではない場合、homeにリダイレクトすること' do
      login(user)
      get media_manage_path(media_manage2)
      expect(response).to redirect_to root_url
    end

    it '非ログインの場合、loginページにリダイレクトすること' do
      get media_manage_path(media_manage)
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'GET /media_manages/[id]/edit' do
    it '自分のmedia_manageの場合、表示に成功すること' do
      login(user)
      get edit_media_manage_path(media_manage)
      expect(response).to have_http_status(200)
      expect(response.body).to include '動画情報編集'
    end

    it '自分のmedia_manageではない場合、homeにリダイレクトすること' do
      login(user)
      get edit_media_manage_path(media_manage2)
      expect(response).to redirect_to root_url
    end

    it '非ログインの場合、loginページにリダイレクトすること' do
      get edit_media_manage_path(media_manage)
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'GET /media_manages/new' do
    it 'ログイン時、アクセスに成功し、新たにできたページにリダイレクトすること' do
      login(user)
      next_id = MediaManage.maximum(:id).next
      get new_media_manage_path
      expect(response).to redirect_to edit_media_manage_url(next_id)
    end

    it '非ログイン時、loginページにリダイレクトすること' do
      get new_media_manage_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'PATCH /media_manages/[id]' do
    let(:param) do
      {
        id: media_manage.id,
        media_manage: {
          title: 'newタイトル',
          media_url: 'url'
        }
      }
    end

    it '自分のmedia_manageの場合、更新に成功すること' do
      login(user)
      patch media_manage_path(media_manage), params: param
      expect(response).to redirect_to media_manage_path(media_manage)
    end

    it '自分のmedia_manageではない場合、rootページにリダイレクトすること' do
      login(user)
      patch media_manage_path(media_manage2), params: param
      expect(response).to redirect_to root_url
    end

    it '非ログインの場合、rootページにリダイレクトすること' do
      patch media_manage_path(media_manage), params: param
      expect(response).to redirect_to new_user_session_url
    end
  end

  describe 'DELETE /media_manages/[id]' do
    it '自分のmedia_manageの場合、削除に成功しmedia_manage一覧ページにリダイレクトすること' do
      login(user)
      delete media_manage_path(media_manage)
      expect(response).to redirect_to media_manages_url
    end

    it '自分のmedia_manageではない場合、rootページにリダイレクトすること' do
      login(user)
      delete media_manage_path(media_manage2)
      expect(response).to redirect_to root_url
    end

    it '非ログインの場合、loginページにリダイレクトすること' do
      delete media_manage_path(media_manage)
      expect(response).to redirect_to new_user_session_url
    end
  end
end
