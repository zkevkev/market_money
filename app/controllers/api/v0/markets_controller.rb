class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    # all combos valid except if city is passed state must also be passed
    search_param_string = params.keys.find { |key| key.include?('search') }
    search_params = JSON.parse(search_param_string)
    city_param = search_params["search"]["city"]
    state_param = search_params["search"]["state"]
    name_param = search_params["search"]["name"]
    if city_param.present? && state_param.nil?
      # error condition
      unprocessable_entity_response
    elsif state_param.nil? && city_param.nil? && name_param.nil?
      # error condition
      unprocessable_entity_response
    elsif state_param.present? && city_param.nil? && name_param.nil?
      # state
      render json: MarketSerializer.new(Market.find_by(state: state_param))
    elsif state_param.nil? && city_param.nil? && name_param.present?
      # name
      render json: MarketSerializer.new(Market.find_by(name: name_param))
    elsif state_param.present? && city_param.present? && name_param.nil?
      # state + city
      render json: MarketSerializer.new(Market.find_by(city: city_param, state: state_param))
    elsif state_param.present? && city_param.nil? && name_param.present?
      # state + name
      render json: MarketSerializer.new(Market.find_by(state: state_param, name: name_param))
    elsif state_param.present? && city_param.present? && name_param.present?
      # state + city + name
      render json: MarketSerializer.new(Market.find_by(city: city_param, state: state_param, name: name_param))
    end
  end

  private

    def unprocessable_entity_response
      render json: ErrorSerializer.new(ErrorMessage.new('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.', 422))
        .serialize_json, status: :unprocessable_entity
    end
end
