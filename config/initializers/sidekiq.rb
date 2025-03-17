require "sidekiq"
require "sidekiq/web"
require "sidekiq/cron/web" if defined?(Sidekiq::Cron)

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379/0" }

  # Schedule periodic jobs
  if defined?(Sidekiq::Cron)
    Sidekiq::Cron::Job.create(
      name: "Sync agents - every hour",
      cron: "0 * * * *",
      class: "SyncAgentsJob"
    )
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] || "redis://localhost:6379/0" }
end

# Protect Sidekiq Web UI in production
if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Replace with a more secure authentication method
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end
end
