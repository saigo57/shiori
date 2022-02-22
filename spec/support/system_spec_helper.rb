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
    find("##{which}-time-input-select_hour").find("option[value=\"#{hour}\"]").select_option unless hour.nil?
    find("##{which}-time-input-select_min").find("option[value=\"#{min}\"]").select_option unless min.nil?
    find("##{which}-time-input-select_sec").find("option[value=\"#{sec}\"]").select_option unless sec.nil?
  end
end
