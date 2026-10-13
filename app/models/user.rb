class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
