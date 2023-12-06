class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request_response
  
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.create!(vendor_params)
    render json: VendorSerializer.new(vendor), status: 201
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(vendor_params)
    render json: VendorSerializer.new(vendor), status: 200
  end

  def destroy
    vendor = Vendor.find(params[:id])
    render json: Vendor.delete(vendor), status: 204
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
