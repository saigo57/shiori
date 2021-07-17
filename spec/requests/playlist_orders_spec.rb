# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlaylistOrders', type: :request do
  let!(:user) { create(:user) }
  let!(:playlist) { create(:playlist, user: user) }
  let!(:playlist2) { create(:playlist2, user: user) }
  let!(:user2) { create(:user2) }
  let!(:user2s_playlist) { create(:playlist, user: user2) }
  let!(:user2s_playlist2) { create(:playlist2, user: user2) }

  before do
    user.confirm
    user2.confirm
  end

  describe 'PATCH /playlist_orders' do
    let(:param) do
      { order: [playlist.id, playlist2.id] }
    end

    it '非ログインの場合、エラーになること' do
      patch playlist_orders_path, params: param
      expect(response).to_not have_http_status(200)
    end

    it '自分のplaylistの場合、更新に成功すること' do
      login(user)
      patch playlist_orders_path, params: param
      expect(response).to have_http_status(200)
    end

    it '自分のplaylistではない場合、エラーになること' do
      login(user)
      patch playlist_orders_path, params: { order: [user2s_playlist.id, user2s_playlist2.id] }
      expect(response).to_not have_http_status(200)
    end
  end
end
