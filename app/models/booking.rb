class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :petsitter
  has_many :bookings_pets, dependent: :destroy
  has_many :pets, through: :bookings_pets
  enum status: { pending: 0, accepted: 1, rejected: 2, completed: 3}
end
