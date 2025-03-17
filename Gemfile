source "https://rubygems.org"

gem "ruby-openai"

ruby "3.4.2"

# Rails framework
gem "rails", "~> 7.1.3"

# Database
gem "pg", "~> 1.5"

# Web server
gem "puma", ">= 5.0"

# API
gem "jbuilder"
gem "rack-cors"

# Background processing
gem "sidekiq"
gem "sidekiq-cron"

# Caching
gem "dalli"  # Memcached client
gem "redis"  # Redis client

# GCP integration
gem "google-cloud-pubsub"
gem "google-cloud-storage"

# Kubernetes integration
gem "kubernetes-client"

# Shopify API
gem "shopify_api"

# Security
gem "bcrypt"
gem "jwt"

# Utilities
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "webmock"
  gem "vcr"
  gem "simplecov", require: false
end
