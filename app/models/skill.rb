class Skill < ApplicationRecord
  CATEGORIES = %w[backend frontend database devops cloud architecture methodology design documentation].freeze
  PROFICIENCIES = %w[proficient intermediate beginner].freeze

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :proficiency, presence: true, inclusion: { in: PROFICIENCIES }

  scope :featured, -> { where(featured: true) }
  scope :by_category, ->(cat) { where(category: cat) }

  default_scope { order(position: :asc) }
end
