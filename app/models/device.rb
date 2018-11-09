class Device < ApplicationRecord
  belongs_to :user

  validates :device_id, presence: true
  validates :device_id, uniqueness: true
end
