class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  # rescue_from ActiveRecord::RecordInvalid, with: :bad_request_response
  # rescue_from ActiveRecord::RecordNotSaved, with: :invalid_record_response

  # refactor this nonsense
  def create
    begin
      market_vendor = MarketVendor.create!(market_vendor_params)
      render json: MarketVendorSerializer.new(market_vendor), status: 201
    rescue ActiveRecord::RecordInvalid => invalid
      market_id = invalid.record.market_id
      vendor_id = invalid.record.vendor_id
      if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id).present?
        render json: ErrorSerializer.new(ErrorMessage.new("Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists", 422))
        .serialize_json, status: :unprocessable_entity
      elsif market_id.nil? || vendor_id.nil?
        render json: ErrorSerializer.new(ErrorMessage.new(invalid.message, 400))
        .serialize_json, status: :bad_request
      elsif market_id != nil && vendor_id != nil
        render json: ErrorSerializer.new(ErrorMessage.new(invalid.message, 404))
        .serialize_json, status: :not_found
      end
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    if market_vendor.nil?
      render json: ErrorSerializer.new(ErrorMessage.new("No MarketVendor with market_id=#{market_vendor_params[:market_id]} AND vendor_id=#{market_vendor_params[:vendor_id]} exists", 404))
        .serialize_json, status: :not_found
    else
      render json: MarketVendor.delete(market_vendor), status: 204
    end
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def not_found_response(exception)
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
        .serialize_json, status: :not_found
    end

    # def bad_request_response(exception)
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    #     .serialize_json, status: :bad_request
    # end

    # def invalid_record_response(exception)
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    #     .serialize_json, status: :invalid_record
    # end
end
