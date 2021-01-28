# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist, type: :model do
  let(:media_manage) { create(:media_manage) }
  let(:user) { media_manage.user }
  let!(:playlist) { create(:playlist, user: user) }
  let!(:playlist_media_manage) do
    create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
  end

  context 'cascade' do
    it 'PlaylistMediaManageが削除されたとき、playlistは削除されないこと' do
      expect(Playlist.count(:id)).to eq 1
      playlist_media_manage.delete
      expect(Playlist.count(:id)).to eq 1
    end
  end
end
