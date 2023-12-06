class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market_id, :vendor_id, presence: true
  # validates_uniqueness_of :market_id, scope: :vendor_id

  # validates :validate_uniqueness

  private

    def validate_uniqueness
      market_vendor = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
      if market_vendor != self or nil
        errors.add(:market_id, "Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
      end
    end
end
