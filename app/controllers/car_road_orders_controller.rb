class CarRoadOrdersController < ApplicationController
  before_action :authenticate_request!
  
  rescue_from CanCan::AccessDenied, with: :not_authorized
  
  before_action :set_car_road_order, only: [:show, :update, :destroy]

  # GET /car_road_orders
  def index
    @car_road_orders = CarRoadOrder.accessible_by(current_ability)
    
    if params[:road_order_id] and params[:car_number]
      @car_road_orders = @car_road_orders
        .where(road_order_id: params[:road_order_id])
        .includes(:car)
        .where(cars: { number: params[:car_number] })
    end
    
    render json: @car_road_orders.includes(movements: :definition)
  end

  # GET /car_road_orders/1
  def show
    render json: @car_road_order
  end

  # POST /car_road_orders
  def create
    # retrieve road order to construct car road order for authorization -- car is not considered for authorization
    road_order = RoadOrder.find_by_id(car_road_order_params[:road_order_id])
    @car_road_order = CarRoadOrder.new(road_order: road_order)
    authorize! :create, @car_road_order
    
    # find matching car (or build new object if one does not exist)
    car_number = car_road_order_params[:car_number]
    @car_road_order.car = Car.find_or_initialize_by(contract_id: road_order.contract.id, car_type: road_order.car_type, number: car_number)
    
    # create movements for the road order definitions
    Definition.where(road_order_id: road_order.id).each do |definition|
      @car_road_order.movements.build(definition: definition)
    end
    
    # create positions to be held by the operators
    road_order.positions.each do |pos|
      @car_road_order.positions.build(name: pos, allows_multiple: false)
    end
    
    # create generic "snags" position
    @car_road_order.positions.build(name: "SNAGS", allows_multiple: true)
    
    if @car_road_order.save
      render json: @car_road_order, status: :created, location: @car_road_order
    else
      render json: @car_road_order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /car_road_orders/1
  def update
    if @car_road_order.update(car_road_order_params)
      render json: @car_road_order
    else
      render json: @car_road_order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /car_road_orders/1
  def destroy
    @car_road_order.destroy
  end
  
  protected
  
  def not_authorized
    head :forbidden
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_car_road_order
    @car_road_order = CarRoadOrder.find(params[:id])
  end
  
  # Only allow a trusted parameter "white list" through.
  def car_road_order_params
    params.require(:car_road_order).permit(:road_order_id, :car_number)
  end
end
