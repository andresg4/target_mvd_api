# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :targets, dependent: :destroy

  enum gender: { male: 0, female: 1 }

  validates :name, :gender, presence: true
  validates :name, length: { maximum: 30 }
  validates :gender, inclusion: { in: genders.keys }, if: proc { |user| user.gender.present? }
  validates :uid, uniqueness: { scope: :provider }

  def self.from_social_provider(provider, params)
    User.where(provider: provider, uid: params[:id]).first_or_create do |user|
      user.name = params[:name]
      user.email = params[:email]
      user.password = Devise.friendly_token[8, 20]
      user.gender = params[:gender] || 0
    end
  end
end
