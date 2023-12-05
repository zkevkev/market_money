class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request
  
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  # should this be using the serializer? (probably)
  def create
    vendor = render json: Vendor.new(vendor_params)
    if vendor.save!
      render json: Vendor.create!(vendor_params), status: 201
    else
      
    end
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def bad_request_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
      .serialize_json, status: :bad_request
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
