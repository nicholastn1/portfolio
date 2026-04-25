class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_locale

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_locale
    locale = params[:locale] || cookies[:locale] || extract_locale_from_accept_language || "pt"
    I18n.locale = locale.to_s.start_with?("en") ? :en : :pt
    FastGettext.locale = I18n.locale == :en ? "en" : "pt_BR"
    cookies[:locale] = { value: I18n.locale.to_s, expires: 1.year.from_now }
  end

  def extract_locale_from_accept_language
    header = request.env["HTTP_ACCEPT_LANGUAGE"]
    return nil unless header

    header.scan(/[a-z]{2}(?:-[A-Z]{2})?/).find do |lang|
      lang.start_with?("en") || lang.start_with?("pt")
    end
  end

  def default_url_options
    if I18n.locale == :en
      { locale: "en" }
    else
      {}
    end
  end
end
