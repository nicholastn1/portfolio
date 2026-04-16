class Language < ApplicationRecord
  include Localizable
  localized_field :name, :level

  validates :name_pt, presence: true
  validates :proficiency, presence: true

  default_scope { order(position: :asc) }
end
