# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user_registration', type: :system, js: true do
  let(:alice) { build(:alice) }
  let(:bob) { create(:bob) }

  before do
    visit root_path
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  def input_valid_account_info
    fill_in 'user[email]', with: alice.email
    fill_in 'user[password]', with: alice.password
    fill_in 'user[password_confirmation]', with: alice.password
  end

  scenario 'サインアップ成功' do
    expect(ActionMailer::Base.deliveries).to be_empty

    within('nav') { click_link 'サインアップ' }
    within('h2') { expect(page).to have_content 'サインアップ' }

    input_valid_account_info

    within('#new_user') { click_on 'サインアップ' }

    expect(page).to have_content('本人確認用のメールを送信しました。')

    # ユーザー有効化メールが送信される
    expect(ActionMailer::Base.deliveries.count).to eq 1

    activate_mail = ActionMailer::Base.deliveries.first
    expect(activate_mail.body.encoded).to match(alice.email)
    expect(activate_mail.body.encoded).to match(alice.email)

    # まだログインできない
    within('nav') { click_link 'ログイン' }
    fill_in 'user[email]', with: alice.email
    fill_in 'user[password]', with: alice.password
    within('#new_user') { click_on 'ログイン' }
    expect(page).to have_content 'メールアドレスの本人確認が必要です'

    # メール内のリンクをパースしたURLに移動してアカウントを有効化
    activate_url = activate_mail.body.encoded.match(/href="(?<url>.+?)">/)[:url]
    visit activate_url
    expect(page).to have_content 'メールアドレスが確認できました'

    # ログイン
    login(alice)

    expect(page).to have_content 'ログインしました'
  end

  scenario '認証メール再送' do
    expect(ActionMailer::Base.deliveries).to be_empty

    within('nav') { click_link 'サインアップ' }

    input_valid_account_info
    within('#new_user') { click_on 'サインアップ' }

    # ユーザー有効化メールが送信される
    expect(ActionMailer::Base.deliveries.count).to eq 1
    first_activate_mail = ActionMailer::Base.deliveries.first
    expect(first_activate_mail.body.encoded).to match(alice.email)
    # メール内のリンクをメモ
    first_activate_url = first_activate_mail.body.encoded.match(/href="(?<url>.+?)">/)[:url]

    # メールをリセット
    ActionMailer::Base.deliveries.clear
    expect(ActionMailer::Base.deliveries).to be_empty

    # 認証メールを再送
    within('nav') { click_link 'サインアップ' }
    click_link '認証メールが届きませんか?'
    within('h2') { expect(page).to have_content '認証メール再送' }
    fill_in 'user[email]', with: alice.email
    click_on '送信'

    # ユーザー有効化メールが再送される
    expect(ActionMailer::Base.deliveries.count).to eq 1
    second_activate_mail = ActionMailer::Base.deliveries.first
    expect(second_activate_mail.body.encoded).to match(alice.email)
    second_activate_url = second_activate_mail.body.encoded.match(/href="(?<url>.+?)">/)[:url]

    # 一回目と二回目で同じURLか
    expect(second_activate_url).to eq first_activate_url
  end

  describe 'サインアップ失敗' do
    scenario 'アカウント入力情報が不正' do
      within('nav') { click_link 'サインアップ' }
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      within('#new_user') { click_on 'サインアップ' }

      expect(page).to have_content 'メールアドレス が入力されていません。'
      expect(page).to have_content 'パスワード が入力されていません。'
    end

    scenario 'アカウント有効化メールが不正' do
      expect(ActionMailer::Base.deliveries).to be_empty
      within('nav') { click_link 'サインアップ' }
      input_valid_account_info
      within('#new_user') { click_on 'サインアップ' }

      # ユーザー有効化メールが送信される
      expect(ActionMailer::Base.deliveries.count).to eq 1
      activate_mail = ActionMailer::Base.deliveries.first

      # メールから有効化URLを抜き出し、token部分を不正値に置き換えてアクセスする
      activate_url = activate_mail.body.encoded.match(/href="(?<url>.+?)">/)[:url]
      token = activate_url.match(%r{/users/confirmation\?confirmation_token=(?<token>.+?)$})[:token]
      invalid_url = activate_url.gsub(token, 'invalid_token') # token置き換え
      visit invalid_url

      expect(page).to have_content 'パスワード確認用トークン が不正です'
    end
  end

  describe 'ユーザー更新' do
    before do
      login(bob)
      toggle_side_nav
      within('#sidenav-menu') { click_link 'ユーザー設定' }
    end

    scenario 'メールアドレス変更' do
      expect(ActionMailer::Base.deliveries).to be_empty
      new_email = 'bobnew@example.com'
      fill_in 'user[email]', with: new_email
      fill_in 'user[current_password]', with: bob.password
      click_on '更新'
      expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレス'

      # ユーザー有効化メールが送信される
      expect(ActionMailer::Base.deliveries.count).to eq 1
      activate_mail = ActionMailer::Base.deliveries.first
      activate_url = activate_mail.body.encoded.match(/href="(?<url>.+?)">/)[:url]

      # メール確認前
      toggle_side_nav
      within('#sidenav-menu') { click_link 'ユーザー設定' }
      expect(page).to have_content "次メールアドレスの確認を待っています: #{new_email}"

      # メール確認
      visit activate_url
      expect(page).to have_content 'メールアドレスが確認できました'

      # 新しいメールアドレスでログイン
      bob.email = new_email
      login(bob)
      expect(page).to have_content 'ログインしました'
    end

    scenario 'メールアドレス更新失敗 パスワードなし' do
      new_email = 'bobnew@example.com'
      fill_in 'user[email]', with: new_email
      click_on '更新'
      expect(page).to have_content '現在のパスワード が空欄です'
    end

    scenario 'パスワード変更' do
      # パスワード不一致
      new_password = 'bobnewpassword'
      fill_in 'user[password]', with: new_password
      fill_in 'user[password_confirmation]', with: 'a' * 6
      fill_in 'user[current_password]', with: bob.password
      click_on '更新'
      expect(page).to have_content '確認用パスワード が一致していません'

      # 正しいパスワード
      fill_in 'user[password]', with: new_password
      fill_in 'user[password_confirmation]', with: new_password
      fill_in 'user[current_password]', with: bob.password
      click_on '更新'
      expect(page).to have_content 'アカウント情報を変更しました'

      # 新しいパスワードでログイン
      within('nav') { click_link 'ログアウト' }
      expect(page).to have_content 'ログアウトしました。'
      bob.password = new_password
      login(bob)
      expect(page).to have_content 'ログインしました'
    end

    scenario 'ユーザー削除' do
      page.accept_confirm('本当に削除してよろしいですか？') do
        click_on 'アカウントを削除する'
      end
      expect(page).to have_content 'アカウントを削除しました'
    end

    scenario 'ユーザー削除 キャンセル' do
      page.dismiss_confirm('本当に削除してよろしいですか？') do
        click_on 'アカウントを削除する'
      end
      expect(page).to have_content 'ユーザー情報編集'
    end
  end
end
