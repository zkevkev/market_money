class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end