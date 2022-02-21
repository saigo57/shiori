# frozen_string_literal: true

module SystemSpecHelper
  def take_screenshot
    page.save_screenshot "screenshot-#{DateTime.now}.png"
  end

  def login(user, with_login: false)
    visit new_user_session_path if with_login
    click_on 'ログイン'
    within('.page-title') { expect(page).to have_content 'ログイン' }
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    within('#new_user') { click_on 'ログイン' }
  end

  def toggle_side_nav
    find('nav').first('a').click
  end

  def fill_in_time(which, hour: nil, min: nil, sec: nil)
    fill_in "#{which}-time-input-hour", with: hour unless hour.nil?
    fill_in "#{which}-time-input-min",  with: min  unless min.nil?
    fill_in "#{which}-time-input-sec",  with: sec  unless sec.nil?
  end
end
