# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'infinite_scroll', type: :system, js: true do
  let!(:alice) { create(:alice) }
  let!(:playlist) { create(:playlist, user: alice, name: 'プレイリスト') }

  def scroll_bottom
    execute_script(
      <<-SCRIPT
        var element = document.documentElement;
        var bottom = element.scrollHeight - element.clientHeight;
        window.scroll(0,bottom);
      SCRIPT
    )
  end

  before do
    50.times do |i|
      media_manage = create(:alices_media_manage, user: alice, title: "動画#{i + 1}", media_sec: i + 1,
                                                  media_url: "http://media#{i + 1}.example.com")
      create(:playlist_media_manage, playlist: playlist, media_manage: media_manage)
    end

    visit root_path
    login(alice)
  end

  shared_examples_for 'infinite-scroll-test' do
    it do
      expect(page).to have_content('動画20')
      expect(page).to_not have_content('動画21')

      scroll_bottom

      expect(page).to have_content('動画21')
      expect(page).to have_content('動画40')
      expect(page).to_not have_content('動画41')

      scroll_bottom

      expect(page).to have_content('動画41')
      expect(page).to have_content('動画50')
    end
  end

  describe 'media_manage indexページ' do
    before do
      visit media_manages_path
    end

    it_behaves_like 'infinite-scroll-test'
  end

  describe 'playlistページ' do
    before do
      visit playlist_path(playlist)
    end

    it_behaves_like 'infinite-scroll-test'
  end
end
