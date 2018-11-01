class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :title, length: { maximum: 20 }
  validates :title, uniqueness: true

  validates :radius, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_on_create, on: :create

  private

  LIMIT_TARGETS = 10

  def validate_on_create
    return unless user

    return unless user.targets.count >= LIMIT_TARGETS

    errors.clear
    errors.add(:user, :exceeded_quota)
  end
end
