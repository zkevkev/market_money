require 'rails_helper'

describe 'Markets API' do
  context 'happy path' do
    it 'sends a list of markets' do
      create_list(:market, 3)

      get '/api/v0/markets'

      expect(response).to be_successful
      
      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets[:data].count).to eq(3)

      markets = markets[:data]

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)

        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)

        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)

        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)

        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)

        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a(String)

        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a(String)

        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a(String)

        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_a(Integer)
      end
    end

    it 'sends a single market' do
      market = create(:market)

      get "/api/v0/markets/#{market.id}"

      expect(response).to be_successful

      market = JSON.parse(response.body, symbolize_names: true)

      expect(market).to be_a(Hash)

      market = market[:data]

      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_a(Integer)
    end

    describe 'search function' do
      it 'allows the user to search by state only' do
        market = create(:market, state: 'CO')
        other_market = create(:market, city: 'Baltimore', state: 'MD', name: "Mark's Market")
        search_params = { state: 'CO' }
        headers = {'CONTENT_TYPE' => 'application/json'}

        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to be_successful

        market_info = JSON.parse(response.body, symbolize_names: true)

        expect(market_info).to be_a(Hash)

        market_info = market_info[:data]

        expect(market_info).to have_key(:id)
        expect(market_info[:id]).to eq(market.id.to_s)

        expect(market_info[:attributes]).to have_key(:name)
        expect(market_info[:attributes][:name]).to eq(market.name)

        expect(market_info[:attributes]).to have_key(:street)
        expect(market_info[:attributes][:street]).to eq(market.street)

        expect(market_info[:attributes]).to have_key(:city)
        expect(market_info[:attributes][:city]).to eq(market.city)

        expect(market_info[:attributes]).to have_key(:county)
        expect(market_info[:attributes][:county]).to eq(market.county)

        expect(market_info[:attributes]).to have_key(:state)
        expect(market_info[:attributes][:state]).to eq(market.state)

        expect(market_info[:attributes]).to have_key(:zip)
        expect(market_info[:attributes][:zip]).to eq(market.zip)

        expect(market_info[:attributes]).to have_key(:lat)
        expect(market_info[:attributes][:lat]).to eq(market.lat)

        expect(market_info[:attributes]).to have_key(:lon)
        expect(market_info[:attributes][:lon]).to eq(market.lon)

        expect(market_info[:attributes]).to have_key(:vendor_count)
        expect(market_info[:attributes][:vendor_count]).to be_a(Integer)
      end

      it 'allows the user to search by name only' do
        market = create(:market, name: 'Agatha Christie')
        other_market = create(:market, city: 'Baltimore', state: 'MD', name: "Mark's Market")
        search_params = ({
                        name: 'Agatha Christie'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to be_successful

        market_info = JSON.parse(response.body, symbolize_names: true)

        expect(market_info).to be_a(Hash)

        market_info = market_info[:data]

        expect(market_info).to have_key(:id)
        expect(market_info[:id]).to eq(market.id.to_s)

        expect(market_info[:attributes]).to have_key(:name)
        expect(market_info[:attributes][:name]).to eq(market.name)

        expect(market_info[:attributes]).to have_key(:street)
        expect(market_info[:attributes][:street]).to eq(market.street)

        expect(market_info[:attributes]).to have_key(:city)
        expect(market_info[:attributes][:city]).to eq(market.city)

        expect(market_info[:attributes]).to have_key(:county)
        expect(market_info[:attributes][:county]).to eq(market.county)

        expect(market_info[:attributes]).to have_key(:state)
        expect(market_info[:attributes][:state]).to eq(market.state)

        expect(market_info[:attributes]).to have_key(:zip)
        expect(market_info[:attributes][:zip]).to eq(market.zip)

        expect(market_info[:attributes]).to have_key(:lat)
        expect(market_info[:attributes][:lat]).to eq(market.lat)

        expect(market_info[:attributes]).to have_key(:lon)
        expect(market_info[:attributes][:lon]).to eq(market.lon)

        expect(market_info[:attributes]).to have_key(:vendor_count)
        expect(market_info[:attributes][:vendor_count]).to be_a(Integer)
      end

      it 'allows the user to search by city and state' do
        market = create(:market, city: 'Denver', state: 'CO')
        other_market = create(:market, city: 'Baltimore', state: 'MD', name: "Mark's Market")
        search_params = ({
                        city: 'Denver',
                        state: 'CO'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to be_successful

        market_info = JSON.parse(response.body, symbolize_names: true)

        expect(market_info).to be_a(Hash)

        market_info = market_info[:data]

        expect(market_info).to have_key(:id)
        expect(market_info[:id]).to eq(market.id.to_s)

        expect(market_info[:attributes]).to have_key(:name)
        expect(market_info[:attributes][:name]).to eq(market.name)

        expect(market_info[:attributes]).to have_key(:street)
        expect(market_info[:attributes][:street]).to eq(market.street)

        expect(market_info[:attributes]).to have_key(:city)
        expect(market_info[:attributes][:city]).to eq(market.city)

        expect(market_info[:attributes]).to have_key(:county)
        expect(market_info[:attributes][:county]).to eq(market.county)

        expect(market_info[:attributes]).to have_key(:state)
        expect(market_info[:attributes][:state]).to eq(market.state)

        expect(market_info[:attributes]).to have_key(:zip)
        expect(market_info[:attributes][:zip]).to eq(market.zip)

        expect(market_info[:attributes]).to have_key(:lat)
        expect(market_info[:attributes][:lat]).to eq(market.lat)

        expect(market_info[:attributes]).to have_key(:lon)
        expect(market_info[:attributes][:lon]).to eq(market.lon)

        expect(market_info[:attributes]).to have_key(:vendor_count)
        expect(market_info[:attributes][:vendor_count]).to be_a(Integer)
      end

      it 'allows the user to search by state and name' do
        market = create(:market, state: 'CO', name: 'Agatha Christie')
        other_market = create(:market, city: 'Baltimore', state: 'MD', name: "Mark's Market")
        search_params = ({
                        state: 'CO',
                        name: 'Agatha Christie'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to be_successful

        market_info = JSON.parse(response.body, symbolize_names: true)

        expect(market_info).to be_a(Hash)

        market_info = market_info[:data]

        expect(market_info).to have_key(:id)
        expect(market_info[:id]).to eq(market.id.to_s)

        expect(market_info[:attributes]).to have_key(:name)
        expect(market_info[:attributes][:name]).to eq(market.name)

        expect(market_info[:attributes]).to have_key(:street)
        expect(market_info[:attributes][:street]).to eq(market.street)

        expect(market_info[:attributes]).to have_key(:city)
        expect(market_info[:attributes][:city]).to eq(market.city)

        expect(market_info[:attributes]).to have_key(:county)
        expect(market_info[:attributes][:county]).to eq(market.county)

        expect(market_info[:attributes]).to have_key(:state)
        expect(market_info[:attributes][:state]).to eq(market.state)

        expect(market_info[:attributes]).to have_key(:zip)
        expect(market_info[:attributes][:zip]).to eq(market.zip)

        expect(market_info[:attributes]).to have_key(:lat)
        expect(market_info[:attributes][:lat]).to eq(market.lat)

        expect(market_info[:attributes]).to have_key(:lon)
        expect(market_info[:attributes][:lon]).to eq(market.lon)

        expect(market_info[:attributes]).to have_key(:vendor_count)
        expect(market_info[:attributes][:vendor_count]).to be_a(Integer)
      end

      it 'allows the user to search by city, state, and name' do
        market = create(:market, city: 'Denver', state: 'CO', name: 'Agatha Christie')
        other_market = create(:market, city: 'Baltimore', state: 'MD', name: "Mark's Market")
        search_params = ({
                        city: 'Denver',
                        state: 'CO',
                        name: 'Agatha Christie'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to be_successful

        market_info = JSON.parse(response.body, symbolize_names: true)

        expect(market_info).to be_a(Hash)

        market_info = market_info[:data]

        expect(market_info).to have_key(:id)
        expect(market_info[:id]).to eq(market.id.to_s)

        expect(market_info[:attributes]).to have_key(:name)
        expect(market_info[:attributes][:name]).to eq(market.name)

        expect(market_info[:attributes]).to have_key(:street)
        expect(market_info[:attributes][:street]).to eq(market.street)

        expect(market_info[:attributes]).to have_key(:city)
        expect(market_info[:attributes][:city]).to eq(market.city)

        expect(market_info[:attributes]).to have_key(:county)
        expect(market_info[:attributes][:county]).to eq(market.county)

        expect(market_info[:attributes]).to have_key(:state)
        expect(market_info[:attributes][:state]).to eq(market.state)

        expect(market_info[:attributes]).to have_key(:zip)
        expect(market_info[:attributes][:zip]).to eq(market.zip)

        expect(market_info[:attributes]).to have_key(:lat)
        expect(market_info[:attributes][:lat]).to eq(market.lat)

        expect(market_info[:attributes]).to have_key(:lon)
        expect(market_info[:attributes][:lon]).to eq(market.lon)

        expect(market_info[:attributes]).to have_key(:vendor_count)
        expect(market_info[:attributes][:vendor_count]).to be_a(Integer)
      end
    end
  end

  context 'sad path' do
    it "will gracefully handle if a market id doesn't exist" do
      get "/api/v0/markets/0"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=0")
    end

    describe 'search function' do
      it 'does not allow the user to search by city without state' do
        market = create(:market, city: 'Denver')
        search_params = ({
                        city: 'Denver'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to_not be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq('422')
        expect(data[:errors].first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
      end

      it 'does not allow the user to search by city and name without state' do
        market = create(:market, city: 'Denver')
        search_params = ({
                        city: 'Denver',
                        name: 'Agatha Christie'
                      })
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to_not be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq('422')
        expect(data[:errors].first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
      end

      it 'must be given at least search parameter' do
        market = create(:market, city: 'Denver')
        search_params = ({})
        headers = {'CONTENT_TYPE' => 'application/json'}
      
        get '/api/v0/markets/search', headers: headers, params: JSON.generate(search: search_params)

        expect(response).to_not be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_a(Array)
        expect(data[:errors].first[:status]).to eq('422')
        expect(data[:errors].first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
      end
    end
  end
end
