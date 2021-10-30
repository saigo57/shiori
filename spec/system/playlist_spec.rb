# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlist', type: :system, js: true do
  let!(:alice) { create(:alice) }
  let!(:playlist1) { create(:playlist, user: alice, name: 'プレイリスト1') }
  let!(:playlist2) { create(:playlist, user: alice, name: 'プレイリスト2') }

  before do
    3.times do |i|
      create(:alices_media_manage, user: alice, title: "media_#{i + 1}", media_url: "http://media#{i + 1}.example.com")
    end

    visit root_path
    login(alice)
  end

  scenario '新規プレイリスト作成・名前変更' do
    # 新規プレイリスト作成
    toggle_side_nav
    within('#sidenav-menu') { click_link '新規プレイリスト' }
    expect(page).to have_content('新規プレイリスト')

    # プレイリスト名変更
    find('.dropdown-trigger').click
    find('.playlist-title-edit').click
    fill_in 'playlist[name]', with: 'newプレイリスト'
    click_on '更新'
    expect(page).to have_content('プレイリスト情報を更新しました')
    expect(page).to have_content('newプレイリスト')

    # side_navにプレイリストが登録される
    visit root_path
    toggle_side_nav
    expect(page).to have_content('newプレイリスト')
  end

  def add_media_to_playlist(media, playlist)
    toggle_side_nav
    click_link '動画一覧'
    click_link media
    click_on 'プレイリスト'
    find('label', text: playlist).click
    expect(page).to have_content('プレイリストに追加しました')
    click_on '閉じる'
  end

  scenario 'プレイリストに動画を追加・削除' do
    # media_1, 2をプレイリスト1に追加
    add_media_to_playlist('media_1', 'プレイリスト1')
    add_media_to_playlist('media_2', 'プレイリスト1')

    # media_3をプレイリスト2に追加
    add_media_to_playlist('media_3', 'プレイリスト2')

    # プレイリスト1に追加されていることを確認
    toggle_side_nav
    click_link 'プレイリスト1'
    expect(page).to have_content('media_1')
    expect(page).to have_content('media_2')
    expect(page).to_not have_content('media_3')

    # プレイリスト2に追加されていることを確認
    toggle_side_nav
    click_link 'プレイリスト2'
    expect(page).to_not have_content('media_1')
    expect(page).to_not have_content('media_2')
    expect(page).to have_content('media_3')

    # プレイリスト1からmedia_1を削除
    toggle_side_nav
    click_link '動画一覧'
    click_link 'media_1'
    click_on 'プレイリスト'
    find('label', text: 'プレイリスト1').click
    expect(page).to have_content('プレイリストから削除しました')
    click_on '閉じる'

    toggle_side_nav
    click_link 'プレイリスト1'
    expect(page).to_not have_content('media_1')
    expect(page).to have_content('media_2')
    expect(page).to_not have_content('media_3')
  end

  scenario 'プレイリスト1を削除(キャンセル)' do
    toggle_side_nav
    click_link 'プレイリスト1'
    find('.dropdown-trigger').click
    click_link 'プレイリスト削除'
    click_on 'キャンセル'

    # 削除されていないことを確認
    visit root_path
    toggle_side_nav
    expect(page).to have_content('プレイリスト1')
  end

  scenario 'プレイリスト1を削除(実行)' do
    toggle_side_nav
    click_link 'プレイリスト1'
    find('.dropdown-trigger').click
    click_link 'プレイリスト削除'
    click_on '削除'

    # 削除されていることを確認
    visit root_path
    toggle_side_nav
    expect(page).to_not have_content('プレイリスト1')
  end

  scenario 'プレイリストに戻る' do
    add_media_to_playlist('media_1', 'プレイリスト1')

    toggle_side_nav
    click_link 'プレイリスト1'
    click_link 'media_1'

    click_link 'プレイリスト[プレイリスト1] に戻る'

    have_content 'プレイリスト1'
  end
end
