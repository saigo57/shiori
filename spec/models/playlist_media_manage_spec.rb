# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaylistMediaManage, type: :model do
  let!(:user) { create(:user) }
  let!(:playlist) { create(:playlist, user: user) }
  let!(:media_manage) { create(:media_manage, user: user) }
  let!(:playlist_media_manage) do
    create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
  end

  context 'cascade' do
    it 'playlistが削除されたとき、このモデルも削除されること' do
      expect(PlaylistMediaManage.count(:id)).to eq 1
      playlist.destroy
      expect(PlaylistMediaManage.count(:id)).to eq 0
    end

    it 'media_manageが削除されたとき、このモデルも削除されること' do
      expect(PlaylistMediaManage.count(:id)).to eq 1
      media_manage.destroy
      expect(PlaylistMediaManage.count(:id)).to eq 0
    end
  end
end
