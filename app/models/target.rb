class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :title, length: { maximum: 20 }
  validates :title, uniqueness: true
end
