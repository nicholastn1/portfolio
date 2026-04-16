module Localizable
  extend ActiveSupport::Concern

  class_methods do
    def localized_field(*fields)
      fields.each do |field|
        define_method(field) do |locale = I18n.locale|
          lang = locale.to_s.start_with?("pt") ? "pt" : "en"
          send(:"#{field}_#{lang}")
        end
      end
    end
  end
end
