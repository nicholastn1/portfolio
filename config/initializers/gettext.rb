require "gettext"
require "gettext_i18n_rails"

# FastGettext configuration (used by gettext_i18n_rails)
FastGettext.add_text_domain "app", path: "locale", type: :po
FastGettext.default_text_domain = "app"
FastGettext.default_available_locales = [ "en", "pt_BR" ]
FastGettext.default_locale = "pt_BR"

# Configure Rails I18n to match
I18n.available_locales = [ :pt, :en ]
I18n.default_locale = :pt
