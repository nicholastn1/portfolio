class SocialLink < ApplicationRecord
  belongs_to :personal_info

  validates :platform, presence: true
  validates :url, presence: true
  validates :label, presence: true

  default_scope { order(position: :asc) }
end
