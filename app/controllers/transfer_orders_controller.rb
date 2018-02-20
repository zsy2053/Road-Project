class TransferOrdersController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /transfer_orders
  def index
    authorize! :read, TransferOrder
    @transfer_orders = TransferOrder.includes(:station, :contract, :assembly).accessible_by(current_ability)
    # filter by optional parameters if supplied
    if params[:assembly_id]
      @transfer_orders = @transfer_orders.where(assembly_id: params[:assembly_id])
    end
    if params[:station_id]
      @transfer_orders = @transfer_orders.where(station_id: params[:station_id])
    end
    render json: @transfer_orders
  end

  # GET /transfer_orders/id
  def show
    @transfer_order = TransferOrder.find(params[:id])
    authorize! :read, @transfer_order
    render json: @transfer_order, serializer: TransferOrderSerializer
  end

  # POST /transfer_orders
  def create_or_update
    @transfer_order = TransferOrder.where(to_number: params[:to_number]).first_or_initialize
    authorize! :update, @transfer_order
    @transfer_order.assign_attributes(transfer_order_params)
    if @transfer_order.save
      render json: @transfer_order
    else
      render json: @transfer_order.errors, status: :unprocessable_entity
    end
  end

  protected

  def not_authorized
    head :forbidden
  end

  private

  # Only allow a trusted parameter "white list" through.
  def transfer_order_params
    params.require(:transfer_order).permit(
      :order,
      :delivery_device,
      :priority,
      :reason_code,
      :name,
      :code,
      :installation,
      :to_number,
      :car,
      :sort_string,
      :date_entered,
      :date_received_3pl,
      :date_staging,
      :date_shipped_bt,
      :date_received_bt,
      :date_production,
      :station_id,
      :contract_id
    )
  end
end
