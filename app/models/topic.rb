class Topic < ApplicationRecord
  has_many :targets, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :name, uniqueness: true
end
