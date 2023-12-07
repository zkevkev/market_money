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
    elsif state_param.nil? && city_param.nil? && name_param.nil?
      # error condition
    elsif state_param.present? && city_param.nil? && name_param.nil?
      # state
      render json: MarketSerializer.new(Market.find_by(state: state_param.to_sym))
    elsif state_param.nil? && city_param.nil? && name_param.present?
      # name
    elsif state_param.present? && city_param.present? && name_param.nil?
      # state + city
    elsif state_param.present? && city_param.nil? && name_param.present?
      # state + name
    elsif state_param.present? && city_param.present? && name_param.present?
      # state + city + name
    end
  end
end
