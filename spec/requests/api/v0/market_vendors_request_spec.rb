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

    xit 'can delete a market_vendor' do
      market = create(:market)      
      vendor = create(:vendor)
      # market.vendors << vendor
      market_vendor = create(:market_vendor, market: market, vendor: vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {'CONTENT_TYPE' => 'application/json'}

      expect(MarketVendor.count).to eq(1)

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to be_successful
      expect(MarketVendor.count).to eq(0)
      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
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
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq('Validation failed: Market must exist')
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
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq('Validation failed: Vendor must exist')
    end

    it 'create will gracefully handle if an id is not provided' do
      market = create(:market)
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: nil
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('400')
      expect(data[:errors].first[:detail]).to eq("Validation failed: Vendor must exist, Vendor can't be blank")
    end

    it 'create will gracefully handle if a market_vendor already exists with given ids' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = create(:market_vendor, market: market, vendor: vendor)
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: vendor.id
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('422')
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end

    xit "delete will gracefully handle if vendor id does not exist" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: vendor.id
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{vendor.id} exists")
    end
  end
end
