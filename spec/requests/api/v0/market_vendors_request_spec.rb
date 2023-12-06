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

  context 'sad path' do
    it "create will gracefully handle if a market id doesn't exist" do
      vendor = create(:vendor)
      market_vendor_params = ({
                      market_id: 0,
                      vendor_id: vendor.id
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market must exist")
    end

    it "create will gracefully handle if a vendor id doesn't exist" do
      market = create(:market)
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: 0
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Validation failed: Vendor must exist")
    end

    it 'create will gracefully handle if a market_vendor already exists with given ids' do
      
    end
  end
end