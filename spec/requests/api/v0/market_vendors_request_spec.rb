require 'rails_helper'

describe 'MarketVendors API' do
  context 'happy path' do
    it 'can create a new market_vendor' do
      market = create(:market)      
      vendor = create(:vendor)
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: vendor.id
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      created_market_vendor = MarketVendor.last

      expect(response).to be_successful
      expect(created_market_vendor.market_id).to eq(market_vendor_params[:market_id])
      expect(created_market_vendor.vendor_id).to eq(market_vendor_params[:vendor_id])
    end
  end
end