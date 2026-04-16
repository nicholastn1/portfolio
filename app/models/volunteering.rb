class Volunteering < ApplicationRecord
  include Localizable
  localized_field :role

  validates :role_pt, presence: true
  validates :organization, presence: true

  default_scope { order(position: :asc) }
end
