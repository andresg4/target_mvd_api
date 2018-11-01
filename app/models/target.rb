class Target < ApplicationRecord
  LIMIT_TARGETS = 10

  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :title, length: { maximum: 20 }
  validates :title, uniqueness: true

  validates :radius, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_user_limit, on: :create

  private

  def validate_user_limit
    return if user && user.targets.count < LIMIT_TARGETS

    errors.add(:user, :exceeded_quota)
  end
end
