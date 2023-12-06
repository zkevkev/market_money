class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validate :validate_uniqueness

  private

    def validate_uniqueness
      if MarketVendor.find(market_id: :market_id, vendor_id: :vendor_id)
        errors.add(:market_id, "Validation failed: Market vendor asociation between market with market_id=#{:market_id} and vendor_id=#{:vendor_id} already exists")
      end
    end
end
