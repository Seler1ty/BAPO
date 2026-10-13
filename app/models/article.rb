class Article < ApplicationRecord
  belongs_to :user
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  scope :by_author, ->(username) { joins(:user).where(users: { username: username }) }
  scope :by_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  scope :recent, -> { order(created_at: :desc) }

  private

  def generate_slug
    self.slug ||= title.parameterize
  end
end
