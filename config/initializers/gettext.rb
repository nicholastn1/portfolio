require "gettext"
require "gettext_i18n_rails"

# FastGettext configuration (used by gettext_i18n_rails)
FastGettext.add_text_domain "app", path: "locale", type: :po
FastGettext.default_text_domain = "app"
FastGettext.default_available_locales = [ "en", "pt_BR" ]
FastGettext.default_locale = "pt_BR"

# Configure Rails I18n to match.
# `:"pt-BR"` is included because gettext_i18n_rails normalizes the gettext
# locale "pt_BR" into the BCP 47 form ":pt-BR" when it syncs I18n.locale.
# Without it, helpers that call I18n.transliterate (e.g. Active Storage's
# Content-Disposition formatting) raise InvalidLocale on every request.
I18n.available_locales = [ :pt, :en, :"pt-BR" ]
I18n.default_locale = :pt

# Dev only: reload translations when .po files change. FastGettext caches the
# parsed .po at first lookup, so without this you must restart the server every
# time you edit a translation.
if Rails.env.development?
  po_files = Dir.glob(Rails.root.join("locale", "**", "*.po").to_s)

  po_watcher = Rails.application.config.file_watcher.new(po_files) do
    FastGettext.translation_repositories.each_value do |repo|
      repo.reload if repo.respond_to?(:reload)
    end
  end

  Rails.application.config.to_prepare do
    po_watcher.execute_if_updated
  end
end
