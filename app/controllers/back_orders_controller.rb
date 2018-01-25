class BackOrdersController < ApplicationController
  before_action :authenticate_request!
  
  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /back_orders
  def index
    @back_orders = BackOrder.accessible_by(current_ability)
    render json: @back_orders
  end
  
  protected
    
  def not_authorized
    head :forbidden
  end
    
  private
    
  # Only allow a trusted parameter "white list" through.
  def back_order_params
    params.require(:back_order).permit(
      :station_id,
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
      :material)
  end
end

  