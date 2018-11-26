class Target < ApplicationRecord
  LIMIT_TARGETS = 10
  MAX_RADIUS    = 1000
  MIN_RADIUS    = 20

  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :meters,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :title, length: { maximum: 20 }
  validates :title, uniqueness: true

  validates :radius, numericality: { greater_than_or_equal_to: MIN_RADIUS }
  validates :radius, numericality: { less_than_or_equal_to: MAX_RADIUS }

  validate :validate_user_limit, on: :create

  def match_targets
    targets_in_range = Target.where("user_id != #{user_id}")
                             .where("topic_id = #{topic_id}")
                             .includes(user: :devices)
                             .within((radius + MAX_RADIUS),
                                     origin: [latitude, longitude])
    find_matches(targets_in_range)
  end

  private

  def find_matches(targets_in_range)
    targets = []
    targets_in_range.find_each do |target_each|
      distance = distance_to(target_each)
      targets.push(target_each) if distance <= target_each.radius + radius
    end
    targets
  end

  def validate_user_limit
    return if user && user.targets.count < LIMIT_TARGETS

    errors.add(:user, :exceeded_quota)
  end
end
