source "https://rubygems.org"

ruby "3.3.1"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

gem 'devise'
gem 'devise-jwt'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  gem 'factory_bot_rails'
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails", "~> 6.1.0"
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers', '~> 6.0'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

