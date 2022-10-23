# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', groups: %w[test development], require: false
gem 'pg', groups: :production, require: false
# Use Puma as the app server
gem 'cssbundling-rails'
gem 'jbuilder', '~> 2.7'
gem 'jsbundling-rails'
gem 'propshaft', '~> 0.4.4'
gem 'puma', '~> 4.1'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'activerecord-import'
gem 'aws-sdk-rails', '~> 3'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'google-api-client'
gem 'grape'
gem 'kaminari'
gem 'rmagick'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
