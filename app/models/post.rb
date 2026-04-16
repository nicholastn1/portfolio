class Post < ApplicationRecord
  include Localizable
  localized_field :title, :description

  has_rich_text :body
  has_one_attached :cover_image
  belongs_to :user

  validates :title_pt, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :category, presence: true

  scope :published, -> { where(published: true) }
  scope :by_category, ->(cat) { where(category: cat) }
  scope :recent, -> { order(published_at: :desc) }

  before_validation :generate_slug, if: -> { slug.blank? && title_pt.present? }
  before_save :calculate_reading_time, if: -> { body.present? }

  def to_param
    slug
  end

  private

  def generate_slug
    base_slug = title_pt.parameterize
    self.slug = base_slug
    counter = 1
    while Post.where.not(id: id).exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end

  def calculate_reading_time
    words = body.to_plain_text.split.size
    self.reading_time = (words / 200.0).ceil
  end
end
