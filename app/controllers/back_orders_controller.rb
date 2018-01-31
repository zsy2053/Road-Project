class BackOrdersController < ApplicationController
  before_action :authenticate_request!
  
  rescue_from CanCan::AccessDenied, with: :not_authorized

  before_action :set_back_order, only: [:show]
  # GET /back_orders
  def index
    @back_orders = BackOrder.accessible_by(current_ability)
    render json: @back_orders
  end

  # POST /back_orders
  def create
    @back_orders = {back_orders: [], errors: {}}
    
    unless params["back_orders"].empty?
      tmp = back_order_params(params["back_orders"][0])
      @back_order = BackOrder.new(tmp)
      
      # verify ability now that all attributes have been set
      authorize! :create, @back_order
      
      # ensure all rows have the same contract_id as the first
      contract_id = @back_order.contract_id
      
      begin
        BackOrder.transaction do
          # delete old back orders before saving the new back orders
          deleteOldBackOrders(contract_id)
         
          # create back orders
          params["back_orders"].each do |back_order|
            @back_order = BackOrder.new(back_order_params(back_order))
            
            if @back_order.contract_id == contract_id
              if @back_order.save
                @back_orders[:back_orders][@back_orders[:back_orders].length] = @back_order
              else
                @back_orders[:errors][@back_orders[:errors].length] = @back_order.errors
              end
            else
              if @back_order.contract_id
                @back_orders[:errors][@back_orders[:errors].length] = "different contract"
              else
                @back_order.errors.add(:contract, 'must exist')
                @back_orders[:errors][@back_orders[:errors].length] = @back_order.errors
              end
            end
          end
          
          # interrupt transaction if at least one error was found
          unless @back_orders[:errors].empty?
            raise ActiveRecord::RecordInvalid
          end
          
          # otherwise report success
          render json: @back_orders, status: :created
        end
      rescue ActiveRecord::RecordInvalid
        render json: @back_orders[:errors], status: :unprocessable_entity
      end
    else
      render json: [ "no back orders submitted" ], status: :unprocessable_entity
    end
  end

  # GET /back_orders/1
  def show
    authorize! :read, @back_order
    render json: @back_order
  end
    
  protected
    
  def not_authorized
    head :forbidden
  end
  
  def deleteOldBackOrders(contract_id)
    BackOrder.where('contract_id = ?', contract_id).destroy_all
  end
    
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_back_order
    @back_order = BackOrder.find(params[:id])
  end
  
  # Only allow a trusted parameter "white list" through.
  def back_order_params(my_params)
    my_params.permit(
      :station_id,
      :contract_id,
      :bom_exp_no,
      :mrp_cont,
      :cri,
      :component,
      :material_description,
      :sort_string,
      :assembly,
      :order,
      :item_text_line_1,
      :qty,
      :vendor_name,
      :focused_part_flag
      )
  end
end

  