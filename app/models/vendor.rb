class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, :description, :contact_name, :contact_phone, presence: true
  validate :validate_credit_accepted

  def validate_credit_accepted
    if credit_accepted.nil?
      errors.add(:credit_accepted, "must be true or false")
    end
  end
end
