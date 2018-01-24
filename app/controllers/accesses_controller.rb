class AccessesController < ApplicationController
	before_action :authenticate_request!
	
	def create
		@access = Access.new(access_params)
		authorize! :create, @access
		if @access.save
		  render json: @access, status: :created, location: @access
		else
		  render json: @access.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@access = Access.find(params[:id])
		authorize! :destroy, @access
		@access.destroy
	end

	private
	  # Only allow a trusted parameter "white list" through.
	  def access_params
	    params.require(:access).permit(:contract_id, :user_id)
	  end
end
