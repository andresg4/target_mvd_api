class Target < ApplicationRecord
  LIMIT_TARGETS = 10
  MAX_RADIUS    = 100

  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :title, length: { maximum: 20 }
  validates :title, uniqueness: true

  validates :radius, numericality: { greater_than_or_equal_to: 0 }
  validates :radius, numericality: { less_than_or_equal_to: MAX_RADIUS }

  validate :validate_user_limit, on: :create

  def self.match_targets(target)
    targets_in_range = Target.where("user_id != #{target.user_id}")
                             .where("topic_id = #{target.topic_id}")
                             .includes(user: :devices)
                             .within((target.radius + MAX_RADIUS),
                                     origin: [target.latitude, target.longitude])
    find_matches(targets_in_range, target)
  end

  def self.find_matches(targets_in_range, target)
    targets = []
    targets_in_range.find_each do |target_each|
      distance = target.distance_to(target_each)
      targets.push(target_each) if distance <= target_each.radius + target.radius
    end
    targets
  end

  private

  def validate_user_limit
    return if user && user.targets.count < LIMIT_TARGETS

    errors.add(:user, :exceeded_quota)
  end
end
