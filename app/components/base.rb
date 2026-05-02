# frozen_string_literal: true

class Components::Base < Phlex::HTML
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes
  # Use FastGettext::Translation (not GetText) so _(...) hits the same .po files
  # that gettext_i18n_rails uses everywhere else in the app.
  include FastGettext::Translation

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end
