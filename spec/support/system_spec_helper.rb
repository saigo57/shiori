# frozen_string_literal: true

module SystemSpecHelper
  def take_screenshot
    page.save_screenshot "screenshot-#{DateTime.now}.png"
  end

  def login(user)
    within('nav') { click_link 'ログイン' }
    within('h2') { expect(page).to have_content 'ログイン' }
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    within('#new_user') { click_on 'ログイン' }
  end

  def toggle_side_nav
    find('nav').first('a').click
  end
end
