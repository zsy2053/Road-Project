class RoadOrdersController < ApplicationController
  before_action :authenticate_request!

  # GET /road_orders
  def index
    authorize! :read, RoadOrder
    @road_orders = RoadOrder.includes(:station, :contract).accessible_by(current_ability)
    render json: @road_orders
  end

  def show
    authorize! :read, RoadOrder
    @road_order = RoadOrder.find_by id: params[:id].downcase
    render json: @road_order
  end
end
