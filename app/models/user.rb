# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  enum gender: %i[male female]

  validates :name, :gender, presence: true
  validates :name, length: { maximum: 30 }
  validates :gender, inclusion: { in: genders.keys }, if: :gender_present?
  validates :uid, uniqueness: { scope: :provider }

  private

  def gender_present?
    gender.present?
  end
end
