require "gettext"
require "gettext_i18n_rails"

# GetText configuration
GetText.locale = "pt_BR"

# Configure Rails I18n to match
I18n.available_locales = [ :pt, :en ]
I18n.default_locale = :pt
