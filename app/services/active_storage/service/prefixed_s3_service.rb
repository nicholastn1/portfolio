# Active Storage doesn't autoload its concrete services — they're loaded
# on demand by the Active Storage configurator. Subclassing requires
# explicitly requiring the parent so eager-loading in production works.
require "active_storage/service/s3_service"

module ActiveStorage
  class Service::PrefixedS3Service < Service::S3Service
    # Subclass of the standard S3 service that namespaces every uploaded
    # blob under a fixed prefix. Useful when sharing one bucket between
    # multiple consumers (e.g. Coolify backups under `data/coolify/...`
    # and portfolio uploads under `portfolio-uploads/...`).
    def initialize(prefix:, **options)
      @prefix = prefix.to_s.chomp("/") + "/"
      super(**options)
    end

    private

    def object_for(key)
      bucket.object("#{@prefix}#{key}")
    end
  end
end
