class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    # all combos valid except if city is passed state must also be passed
    if params[:city].present? && params[:state].nil?
      # error condition
    elsif params[:state].nil? && params[:city].nil? && params[:name].nil?
      # error condition
    elsif params[:state].present? && params[:city].nil? && params[:name].nil?
      # state
    elsif params[:state].nil? && params[:city].nil? && params[:name].present?
      # name
    elsif params[:state].present? && params[:city].present? && params[:name].nil?
      # state + city
    elsif params[:state].present? && params[:city].nil? && params[:name].present?
      # state + name
    elsif params[:state].present? && params[:city].present? && params[:name].present?
      # state + city + name
    end
  end
end
