class ContractsController < ApplicationController
  before_action :authenticate_request!

  before_action :set_contract, only: [:show, :update, :destroy]

  # GET /contracts
  def index
    authorize! :read, Contract
    @contracts = Contract.accessible_by(current_ability)
    render json: @contracts
  end

  # GET /contracts/1
  def show
    authorize! :read, @contract
    render json: @contract
  end

  # POST /contracts
  def create
    @contract = Contract.new(contract_params)
    authorize! :create, @contract
    if @contract.save
      render json: @contract, status: :created, location: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contracts/1
  def update
    authorize! :update, @contract
    if @contract.update(contract_params)
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contracts/1
  def destroy
    authorize! :destroy, @contract
    @contract.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contract_params
      params.require(:contract).permit(:site_id, :status, :name, :code, :description, :planned_start, :planned_end, :actual_start, :actual_end, :minimum_offset)
    end
end
