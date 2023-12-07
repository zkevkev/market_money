require 'rails_helper'

describe 'Vendors API' do
  context 'happy path' do
    it 'sends a list of vendors' do
      market = create(:market)
      vendors = create_list(:vendor, 3)
      market.vendors << vendors

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful
      
      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors[:data].count).to eq(3)

      vendors = vendors[:data]

      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
      end
    end

    it 'sends a single vendor' do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(vendor).to be_a(Hash)

      vendor = vendor[:data]

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end

    it 'can create a new vendor' do
      vendor_params = ({
                      name: 'Murder on the Orient Express',
                      description: 'a mystery',
                      contact_name: 'Agatha Christie',
                      contact_phone: '867-5309',
                      credit_accepted: true
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it 'can update a vendor' do
      vendor = create(:vendor)
      vendor_params = ({
                      description: 'a mystery',
                      contact_phone: '867-5309',
                      credit_accepted: true
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      vendor = Vendor.find(vendor.id)

      expect(response).to be_successful
      expect(vendor.description).to eq(vendor_params[:description])
      expect(vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it 'can delete a vendor' do
      vendor = create(:vendor)

      expect(Vendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(Vendor.count).to eq(0)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'sad path' do
    it "index will gracefully handle if a market id doesn't exist" do
      get '/api/v0/markets/0/vendors'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=0")
    end

    it "show will gracefully handle if a vendor id doesn't exist" do
      get '/api/v0/vendors/0'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=0")
    end

    it 'create will gracefully handle if invalid info is entered' do
      vendor_params = ({
                      name: 'Murder on the Orient Express',
                      description: 'a mystery',
                      credit_accepted: true
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('400')
      expect(data[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end

    it "update will gracefully handle if a vendor id doesn't exist" do
      vendor_params = ({
                      description: 'a mystery',
                      contact_phone: '867-5309',
                      credit_accepted: true
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      patch '/api/v0/vendors/0', headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=0")
    end

    it 'update will gracefully handle if invalid data is entered' do
      vendor = create(:vendor)
      vendor_params = ({
                      description: '',
                      contact_phone: '867-5309',
                      credit_accepted: true
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}
    
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('400')
      expect(data[:errors].first[:detail]).to eq("Validation failed: Description can't be blank")
    end

    it "delete will gracefully handle if a vendor id doesn't exist" do
      delete '/api/v0/vendors/0'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=0")
    end
  end
end
