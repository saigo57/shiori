# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sort_playlist', type: :system, js: true do
  let(:alice) { create(:alice) }
  let!(:playlist1) { create(:playlist, user: alice, name: 'プレイリスト1') }
  let!(:playlist2) { create(:playlist, user: alice, name: 'プレイリスト2') }
  let!(:playlist3) { create(:playlist, user: alice, name: 'プレイリスト3') }

  xscenario 'プレイリストの順番を変更' do
    login(alice, with_login: true)
    toggle_side_nav
    sleep(1)

    # TODO: ソートのテストを実装
  end
end
