class RoadOrdersController < ApplicationController
  before_action :authenticate_request!
  
  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /road_orders
  def index
    authorize! :read, RoadOrder
    @road_orders = RoadOrder.includes(:station, :contract).accessible_by(current_ability)
    render json: @road_orders
  end

  def show
    @road_order = RoadOrder.find(params[:id])
    authorize! :read, @road_order
    render json: @road_order
  end
  
  protected
  
  def not_authorized
    head :forbidden
  end
end
