source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 6.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12.6'
gem 'sass-rails', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

gem 'bootstrap', '~>4.3.1'
gem 'devise'
gem 'draper'
gem 'figaro'
gem 'humanize'
gem 'newrelic_rpm'
gem 'pundit'
gem 'jwt'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
  gem 'pry'
  gem 'rspec-rails', '~> 3.9.0'
  gem 'webdrivers'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'geckodriver-helper'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
