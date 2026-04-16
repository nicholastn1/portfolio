class Certification < ApplicationRecord
  include Localizable
  localized_field :name

  validates :name_pt, presence: true
  validates :provider, presence: true

  default_scope { order(position: :asc) }
end
