class Experience < ApplicationRecord
  include Localizable
  localized_field :role, :description, :achievements

  validates :company, presence: true
  validates :role_pt, presence: true
  validates :started_at, presence: true

  default_scope { order(position: :asc) }

  def current?
    ended_at.nil?
  end
end
