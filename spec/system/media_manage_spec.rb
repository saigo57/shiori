# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'media_manage', type: :system, js: true do
  let(:alice) { create(:alice) }
  let!(:media_manage_rails) { create(:media_manage_rails, user_id: alice.id) }

  before do
    visit root_path
    login(alice)
  end

  scenario '新規動画追加' do
    # 新規動画作成ページを表示
    toggle_side_nav
    within('#sidenav-menu') { click_link '新規動画' }
    expect(page).to have_content('動画情報編集')

    # 情報を入力
    title = 'Railsチュートリアル解説動画『お試しプラン』'
    fill_in 'media_manage[title]', with: title
    fill_in 'media_manage[media_url]', with: 'https://www.youtube.com/watch?v=RY_ksGQorQ0'
    click_on '更新'
    expect(page).to have_content('動画情報を更新しました')
    expect(page).to have_content(title)

    # 一覧
    toggle_side_nav
    within('#sidenav-menu') { click_link '動画一覧' }
    expect(page).to have_content(title)
  end

  context '変更系' do
    before do
      toggle_side_nav
      within('#sidenav-menu') { click_link '動画一覧' }
      expect(page).to have_content(media_manage_rails.title)
      click_link media_manage_rails.title
    end

    scenario 'タイトル変更' do
      click_link '編集'
      new_title = 'newタイトル'
      fill_in 'media_manage[title]', with: new_title
      click_on '更新'
      expect(page).to have_content('動画情報を更新しました')
      expect(page).to have_content(new_title)
    end

    scenario '編集-キャンセル' do
      click_link '編集'
      new_title = 'newタイトル'
      fill_in 'media_manage[title]', with: new_title
      click_on 'キャンセル'
      expect(page).to have_content(media_manage_rails.title)
    end

    scenario '削除' do
      click_link '編集'
      click_on 'delete' # 表示はDELETE
      expect(page).to have_content('確認')
      click_on '削除する'
      expect(page).to have_content('動画情報を削除しました')
      expect(page).to_not have_content(media_manage_rails.title)
    end

    scenario '削除-キャンセル' do
      click_link '編集'
      click_on 'delete' # 表示はDELETE
      expect(page).to have_content('確認')
      within('#media_manages_delete_modal') { click_on 'キャンセル' }
      expect(page).to have_content('動画情報編集')
    end

    scenario '視聴時間入力' do
      click_on '＋時間'
      fill_in_time('begin', hour: 1, min: 2, sec: 3)
      fill_in_time('end', hour: 4, min: 5, sec: 6)
      click_on '登録'

      expect(page).to have_content('01:02:03')
      expect(page).to have_content('04:05:06')
    end

    scenario '視聴時間入力(キャンセル)' do
      click_on '＋時間'
      fill_in_time('begin', hour: 1, min: 2, sec: 3)
      fill_in_time('end', hour: 4, min: 5, sec: 6)
      click_on 'キャンセル'

      expect(page).to_not have_content('01:02:03')
      expect(page).to_not have_content('04:05:06')
    end

    scenario '空欄時0として扱われること' do
      click_on '＋時間'
      fill_in_time('end', sec: 1)
      click_on '登録'

      expect(page).to have_content('00:00:00')
      expect(page).to have_content('00:00:01')
    end

    scenario '時間の削除' do
      click_on '＋時間'
      fill_in_time('end', hour: 1)
      click_on '登録'

      click_on '＋時間'
      fill_in_time('begin', hour: 2)
      fill_in_time('end', hour: 3)
      click_on '登録'

      expect(page).to have_content('00:00:00')
      expect(page).to have_content('01:00:00')
      expect(page).to have_content('02:00:00')
      expect(page).to have_content('03:00:00')

      find('#time-span-block-0').find('.time-span-delete').click

      expect(page).to_not have_content('00:00:00')
      expect(page).to_not have_content('01:00:00')
      expect(page).to have_content('02:00:00')
      expect(page).to have_content('03:00:00')
    end

    scenario '一つ前に戻る' do
      # 区間A
      click_on '＋時間'
      fill_in_time('end', hour: 2)
      click_on '登録'

      # まだ戻すボタンがないことを確認
      expect(page).to_not have_content('元に戻す')

      # 区間B
      click_on '＋時間'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 3)
      click_on '登録'

      # マージされていることを確認
      expect(page).to have_content('00:00:00')
      expect(page).to have_content('03:00:00')

      # 戻すボタンが現れたことを確認
      expect(page).to have_content('元に戻す')

      # 戻す
      click_on '元に戻す'
      expect(page).to have_content('確認')
      click_on '戻す'

      expect(page).to have_content('元に戻しました')
      expect(page).to have_content('00:00:00')
      expect(page).to have_content('02:00:00')
      expect(page).to_not have_content('03:00:00')

      # 戻すボタン消えたことを確認
      expect(page).to_not have_content('元に戻す')
    end
  end
end
