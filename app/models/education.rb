class Education < ApplicationRecord
  include Localizable
  localized_field :degree, :course, :activities

  validates :institution, presence: true
  validates :degree_pt, presence: true

  default_scope { order(position: :asc) }
end
