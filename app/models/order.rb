class Order < ApplicationRecord
  belongs_to :bid

  enum status: %i[pending sent delivered]
  validates :arrival_location, :arrival_type, :status, presence: true
end
