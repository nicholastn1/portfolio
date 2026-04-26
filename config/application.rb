require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Portfolio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Active Storage's Configurator uses `Kernel.require` to load custom
    # service adapters by file name (e.g. "active_storage/service/prefixed_s3_service").
    # Zeitwerk autoloads from app/services but doesn't add it to $LOAD_PATH,
    # so we have to do it explicitly for require-by-path to find subclasses
    # such as ActiveStorage::Service::PrefixedS3Service.
    $LOAD_PATH.unshift Rails.root.join("app/services").to_s

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
