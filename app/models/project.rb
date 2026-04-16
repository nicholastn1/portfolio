class Project < ApplicationRecord
  include Localizable
  localized_field :description

  has_one_attached :image

  validates :name, presence: true
  validates :description_pt, presence: true

  default_scope { order(position: :asc) }
end
