# frozen_string_literal: true

# sidekiq default host redis://localhost:6379
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379" }
end
