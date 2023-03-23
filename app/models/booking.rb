class Booking < ApplicationRecord
  belongs_to :listing
  has_many :missions, through: :listings, dependent: :destroy
end
