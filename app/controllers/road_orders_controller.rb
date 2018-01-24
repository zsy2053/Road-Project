class RoadOrdersController < ApplicationController
  before_action :authenticate_request!
  
  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /road_orders
  def index
    authorize! :read, RoadOrder
    @road_orders = RoadOrder.includes(:station, :contract).accessible_by(current_ability)
    render json: @road_orders
  end
  
  # GET /road_orders/1
  def show
    @road_order = RoadOrder.find(params[:id])
    authorize! :read, @road_order
    render json: @road_order, serializer: RoadOrderDetailsSerializer
  end
  
  # POST /road_orders
  def create
    clean_params = road_order_params
    @road_order = RoadOrder.new(clean_params)
    
    # set the current user as the author
    @road_order.author = current_user
    
    # explicitly set the contract object to match station if station set
    if @road_order.station.present?
      @road_order.contract = @road_order.station.contract
    end
    
    # verify ability now that all attributes have been set
    authorize! :create, @road_order
    if @road_order.save
      render json: @road_order, status: :created, location: @road_order
    else
      render json: @road_order.errors, status: :unprocessable_entity
    end
  end
  
  protected
  
  def not_authorized
    head :forbidden
  end
  
  private
  
  # Only allow a trusted parameter "white list" through.
  def road_order_params
    params.require(:road_order).permit(
      :station_id,
      :car_type,
      :start_car,
      :import,
      :work_centre,
      :module,
      { positions: [] },
      { day_shifts: {} },
      { definitions_attributes: [
        :name,
        :description,
        :sequence_number,
        :day,
        :shift,
        :work_location,
        :expected_duration,
        :breaks,
        :expected_start,
        :expected_end,
        :serialized,
        { :positions => [] }
      ] }
    )
  end
end
