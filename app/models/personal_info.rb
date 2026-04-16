class PersonalInfo < ApplicationRecord
  include Localizable
  localized_field :bio, :footer_text

  has_one_attached :profile_image
  has_many :social_links, dependent: :destroy

  validates :name, presence: true
  validates :title, presence: true

  def self.instance
    first_or_initialize
  end
end
