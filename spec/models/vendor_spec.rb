require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    # look into shoulda-matchers docs
    # it { should validate(:validate_credit_accepted) }
  end

  describe 'instance methods' do
    # ask in check in?
    describe '#validate_credit_accepted' do
      it '' do
        
      end
    end
  end
end
