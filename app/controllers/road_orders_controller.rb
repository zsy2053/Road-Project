class RoadOrdersController < ApplicationController
  before_action :authenticate_request!

  # GET /road_orders
  def index
    authorize! :read, RoadOrder
    @road_orders = RoadOrder.includes(:station, :contract).accessible_by(current_ability)
    render json: @road_orders
  end
end
