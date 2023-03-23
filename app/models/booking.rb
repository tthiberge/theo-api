class Booking < ApplicationRecord
  belongs_to :listing
  has_many :missions, through: :listing, dependent: :destroy
  has_many :reservations, through: :listing

end
