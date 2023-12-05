require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  before(:each) do
    @market = create(:market)
  end

  describe 'instance methods' do
    describe '#count_vendors' do
      it 'returns a count of vendors associated with a market' do
        expect(@market.send(:count_vendors)).to eq(0)
        
        vendors = create_list(:vendor, 3)
        @market.vendors << vendors
        
        expect(@market.send(:count_vendors)).to eq(3)
      end
    end
  end
end
