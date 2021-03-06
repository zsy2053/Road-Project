class StationsController < ApplicationController
  before_action :authenticate_request!

  before_action :set_station, only: [:show, :update, :destroy]

  # GET /stations
  def index
    authorize! :read, Station
    @stations = Station.accessible_by(current_ability)

    render json: @stations
  end

  # GET /stations/1
  def show
    authorize! :read, @station
    render json: @station
  end

  # POST /stations
  def create
    @station = Station.new(station_params)
    authorize! :create, @station
    if @station.save
      render json: @station, status: :created, location: @station
    else
      render json: @station.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stations/1
  def update
    authorize! :update, @station
    if @station.update(station_params)
      render json: @station
    else
      render json: @station.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stations/1
  def destroy
    authorize! :destroy, @station
    @station.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def station_params
      params.require(:station).permit(:contract_id, :name, :code)
    end
end
