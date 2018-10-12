class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  enum gender: %i[masculino femenino]

  validates :username, :gender, :password_confirmation, presence: true
  validates :username, length: { maximum: 30 }
  validates :gender, inclusion: { in: genders.keys }, if: :gender_present?

  private

  def gender_present?
    gender.present?
  end
end
