# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'media_manage_span', type: :system, js: true do
  let(:alice) { create(:alice) }
  let!(:media_manage_other_site) { create(:media_manage_other_site, user_id: alice.id) }

  before do
    visit root_path
    login(alice)
  end

  context '視聴時間マージ処理' do
    before do
      toggle_side_nav
      within('#sidenav-menu') { click_link '動画一覧' }
      expect(page).to have_content(media_manage_other_site.title)

      click_link media_manage_other_site.title
    end

    # --A--  --B--
    scenario '2区間が重ならないとき、独立すること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('end', hour: 1)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 2)
      fill_in_time('end', hour: 3)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('01:00:00')
        expect(page).to have_content('02:00:00')
        expect(page).to have_content('03:00:00')
      end
    end

    # --A--
    #    --B--
    scenario '2区間の一部が重なるとき、一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('end', hour: 2)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 3)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('03:00:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('02:00:00')
      end
    end

    # ---A---
    #  --B--
    scenario '既にある区間に収まるような区間が入力された場合、一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('end', hour: 2)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 1, min: 30)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('02:00:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('01:30:00')
      end
    end

    #  --A--
    # ---B---
    scenario '既にある区間を覆うような区間が入力された場合、一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 1, min: 30)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('end', hour: 2)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('02:00:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('01:30:00')
      end
    end

    # --A--  --B--
    #    --C--
    scenario '2区間に跨るように3つ目の区間がある時、全て一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('end', hour: 1)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 2)
      fill_in_time('end', hour: 3)
      click_on '登録'

      # 区間C
      click_on '時間追加'
      fill_in_time('begin', min: 30)
      fill_in_time('end', hour: 2, min: 30)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('03:00:00')
        expect(page).to_not have_content('00:30:00')
        expect(page).to_not have_content('02:30:00')
      end
    end

    # --A--  --B--
    #     ----C----
    scenario '既にある1区間と一部が重なり、もう一つの区間を覆うとき、全て一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('end', hour: 1)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 2)
      fill_in_time('end', hour: 3)
      click_on '登録'

      # 区間C
      click_on '時間追加'
      fill_in_time('begin', min: 30)
      fill_in_time('end', hour: 4)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('04:00:00')
        expect(page).to_not have_content('00:30:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('02:00:00')
        expect(page).to_not have_content('03:00:00')
      end
    end

    #   --A--   --B--
    #  -------C-------
    scenario '既にある2区間をすべて覆うとき、全て一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 2)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 3)
      fill_in_time('end', hour: 4)
      click_on '登録'

      # 区間C
      click_on '時間追加'
      fill_in_time('end', hour: 5)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('05:00:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('02:00:00')
        expect(page).to_not have_content('03:00:00')
        expect(page).to_not have_content('04:00:00')
      end
    end

    #   -A- -B- -C- -D-
    #  --------E--------
    scenario '既にある4区間をすべて覆うとき、全て一つにマージされること' do
      # 区間A
      click_on '時間追加'
      fill_in_time('begin', hour: 1)
      fill_in_time('end', hour: 2)
      click_on '登録'

      # 区間B
      click_on '時間追加'
      fill_in_time('begin', hour: 3)
      fill_in_time('end', hour: 4)
      click_on '登録'

      # 区間C
      click_on '時間追加'
      fill_in_time('begin', hour: 5)
      fill_in_time('end', hour: 6)
      click_on '登録'

      # 区間C
      click_on '時間追加'
      fill_in_time('begin', hour: 7)
      fill_in_time('end', hour: 8)
      click_on '登録'

      # 区間E
      click_on '時間追加'
      fill_in_time('end', hour: 9)
      click_on '登録'

      within('.waching-data-section') do
        expect(page).to have_content('00:00:00')
        expect(page).to have_content('09:00:00')
        expect(page).to_not have_content('01:00:00')
        expect(page).to_not have_content('02:00:00')
        expect(page).to_not have_content('03:00:00')
        expect(page).to_not have_content('04:00:00')
        expect(page).to_not have_content('05:00:00')
        expect(page).to_not have_content('06:00:00')
        expect(page).to_not have_content('07:00:00')
        expect(page).to_not have_content('08:00:00')
      end
    end
  end
end
