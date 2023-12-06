class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request_response

  def create
    market_vendor = MarketVendor.create!(market_vendor_params)
    render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def not_found_response(exception)
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
        .serialize_json, status: :not_found
    end

    def bad_request_response(exception)
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
        .serialize_json, status: :bad_request
    end
end