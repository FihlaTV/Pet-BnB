class Petsitter < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :petsitters_services
  has_many :services, through: :petsitters_services, dependent: :destroy
  enum status: { active: 0, inactive: 1 }
end
