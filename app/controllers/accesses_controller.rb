class AccessesController < ApplicationController
	before_action :authenticate_request!
	rescue_from CanCan::AccessDenied, with: :not_authorized

	def create
		@access = Access.new(access_params)
		authorize! :create, @access
		if @access.save

		  render json: @access, status: :created, location: @access
		else
		  render json: @access.errors, status: :unprocessable_entity
		end
	end

	def multi_update
	  # create transaction to rollback changes if any record is invalid or if the user lacks access
		begin
			Access.transaction do
				# create access records based on the contract_id value and each user_id in the
				# update_ids array and authorize access on each record
				accesses_params[:update_ids].each do |user_id|
					access = Access.new(:user_id => user_id, :contract_id => accesses_params[:contract_id])
					authorize! :create, access
					unless access.save
					  # ignore if access already exists
					  unless access.errors.messages[:user] == ["has already been taken"]
					  	raise ActiveRecord::RecordInvalid
					  end
					end
				end
				
				# check authorization on each access object before deleting
				delete_accesses = Access.where(:user_id => accesses_params[:delete_ids], :contract_id => accesses_params[:contract_id])
				delete_accesses.each do |access|
				  authorize! :destroy, access
				end
				delete_accesses.destroy_all
			end
			
			# return all the users that the current_user can read because the react side needs users collection to render.
			@users = User.includes(accesses: :contract).accessible_by(current_ability)
			render json: @users
		rescue ActiveRecord::RecordInvalid => e
			render json: e, status: :unprocessable_entity
		end
	end

	def destroy
		@access = Access.find(params[:id])
		authorize! :destroy, @access
		@access.destroy
	end

	protected

		def not_authorized
		  head :forbidden
		end

	private
	  # Only allow a trusted parameter "white list" through.
	  def accesses_params
			params.permit(:contract_id, :update_ids => [], :delete_ids => [])
	  end

	  def access_params
	    params.require(:access).permit(:contract_id, :user_id)
	  end
end
