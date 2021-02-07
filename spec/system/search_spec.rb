# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search', type: :system, js: true do
  let!(:alice) { create(:alice) }

  def create_media(params)
    toggle_side_nav
    within('#sidenav-menu') { click_link '新規動画' }

    fill_in 'media_manage[title]', with: params[:title]
    fill_in 'media_manage[media_url]', with: params[:media_url] if params.include?(:media_url)

    fill_in_media_len(params[:media_len]) if params.include?(:media_len)
    click_on '更新'

    input_span(params[:watch_begin], params[:watch_end]) if params.include?(:watch_begin)
  end

  def fill_in_media_len(media_len)
    len = media_len.split(':')
    fill_in 'length-time-input-hour', with: len[0]
    fill_in 'length-time-input-min', with: len[1]
    fill_in 'length-time-input-sec', with: len[2]
  end

  def input_span(watch_begin, watch_end)
    click_on '＋時間'
    begin_list = watch_begin.split(':')
    end_list = watch_end.split(':')
    fill_in_time('begin', hour: begin_list[0], min: begin_list[1], sec: begin_list[2])
    fill_in_time('end', hour: end_list[0], min: end_list[1], sec: end_list[2])
    click_on '登録'
  end

  # 非正規化を行っている関係で、factory_botを使用すると整合性が取れない可能性があるため、
  # 実際のformを用いてテストデータを登録している。
  # かなり遅いためテストケースの数に注意する必要がある
  before do
    visit root_path
    login(alice)

    create_media({ title: 'タイトル1(未視聴) groupA', media_len: '1:0:0' })
    create_media({ title: 'タイトル2(視聴済み) groupA', media_len: '2:0:0', watch_begin: '0:0:0', watch_end: '2:0:0' })
    create_media({ title: 'タイトル3(視聴中) groupB', media_len: '3:0:0', watch_begin: '0:0:0', watch_end: '2:30:0' })
    create_media({ title: 'タイトル4(不明) groupB' })

    visit media_manages_path
  end

  scenario 'チェックボックス' do
    # デフォルトでは'視聴済み'だけ表示されない
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to_not have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to have_content('タイトル4(不明)')

    # '視聴済み'にチェックを入れるとすべて表示される
    find('label', text: '視聴済み').click
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to have_content('タイトル4(不明)')

    # '未視聴'のチェックを外すと未視聴だけ表示されない
    find('label', text: '未視聴').click
    expect(page).to_not have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to have_content('タイトル4(不明)')
    find('label', text: '未視聴').click

    # '視聴中'のチェックを外すと視聴中だけ表示されない
    find('label', text: '視聴中').click
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to_not have_content('タイトル3(視聴中)')
    expect(page).to have_content('タイトル4(不明)')
    find('label', text: '視聴中').click

    # '不明'のチェックを外すと不明だけ表示されない
    find('label', text: '不明').click
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to_not have_content('タイトル4(不明)')
    find('label', text: '不明').click
  end

  scenario '並び替え' do
    # 全てにチェックを入れる
    find('label', text: '視聴済み').click

    # 残り時間の昇順に並んでいること
    cards = page.all('.media-manage-card')
    expect(cards[0]).to have_content('タイトル4(不明)')
    expect(cards[1]).to have_content('タイトル2(視聴済み)')
    expect(cards[2]).to have_content('タイトル3(視聴中)')
    expect(cards[3]).to have_content('タイトル1(未視聴)')

    # 残り時間の降順に並んでいること
    find('.search-sort-order').click
    cards = page.all('.media-manage-card')
    expect(cards[0]).to have_content('タイトル1(未視聴)')
    expect(cards[1]).to have_content('タイトル3(視聴中)')
    expect(cards[2]).to have_content('タイトル2(視聴済み)')
    expect(cards[3]).to have_content('タイトル4(不明)')

    # ソート順を戻す
    find('.search-sort-order').click

    # 動画時間の昇順に並んでいること
    find('#sort_target').find('option[value="media_time"]').select_option
    cards = page.all('.media-manage-card')
    expect(cards[0]).to have_content('タイトル4(不明)')
    expect(cards[1]).to have_content('タイトル1(未視聴)')
    expect(cards[2]).to have_content('タイトル2(視聴済み)')
    expect(cards[3]).to have_content('タイトル3(視聴中)')

    # 動画時間の降順に並んでいること
    find('.search-sort-order').click
    cards = page.all('.media-manage-card')
    expect(cards[0]).to have_content('タイトル3(視聴中)')
    expect(cards[1]).to have_content('タイトル2(視聴済み)')
    expect(cards[2]).to have_content('タイトル1(未視聴)')
    expect(cards[3]).to have_content('タイトル4(不明)')
  end

  scenario '検索' do
    # すべて表示する
    find('label', text: '視聴済み').click
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to have_content('タイトル4(不明)')

    # groupAが含まれている項目のみ検索される
    fill_in 'keywords', with: 'groupA'
    click_on '検索'
    expect(page).to have_content('タイトル1(未視聴)')
    expect(page).to have_content('タイトル2(視聴済み)')
    expect(page).to_not have_content('タイトル3(視聴中)')
    expect(page).to_not have_content('タイトル4(不明)')

    # groupBかつ視聴が含まれている項目のみ検索される
    fill_in 'keywords', with: 'groupB 視聴'
    click_on '検索'
    expect(page).to_not have_content('タイトル1(未視聴)')
    expect(page).to_not have_content('タイトル2(視聴済み)')
    expect(page).to have_content('タイトル3(視聴中)')
    expect(page).to_not have_content('タイトル4(不明)')

    # URLも検索されることを確認
    create_media({ title: 'URLテスト', media_url: 'https://example.com/testurl' })
    visit media_manages_path
    fill_in 'keywords', with: 'testurl'
    click_on '検索'
    expect(page).to have_content('URLテスト')
    expect(page).to_not have_content('タイトル1(未視聴)')
    expect(page).to_not have_content('タイトル2(視聴済み)')
    expect(page).to_not have_content('タイトル3(視聴中)')
    expect(page).to_not have_content('タイトル4(不明)')
  end
end
