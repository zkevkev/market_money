class Market < ApplicationRecord
  before_save { |market| market.vendor_count = count_vendors }

  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true

  private
    def count_vendors
      vendors.count
    end
end
