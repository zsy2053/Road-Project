class WorksController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /work_records
  def index
    authorize! :read, Work
    @work_records = Work.accessible_by(current_ability)

    if params[:movement_id]
      @work_records = @work_records.where(parent_id: params[:movement_id])
    elsif params[:snag_id]
      @work_records = @work_records.where(parent_id: params[:snag_id])
    end

    render json: @work_records
  end

  # GET /work_records/id
  def show
    @work_record = Work.find(params[:id])
    authorize! :read, @work_record
    render json: @work_record
  end

  # POST /work_record
  def create
    authorize! :create, Work
    @work_record = Work.new(work_params)
    if @work_record.save
      render json: @work_record, status: :created
    else
      render json: @work_record.errors, status: :unprocessable_entity
    end
  end

  protected

  def not_authorized
    head :forbidden
  end

  private
    # Only allow a trusted parameter "white list" through.
    def work_params
      params.require(:work).permit(
        :operator_id,
        :actual_time,
        :override_time,
        :action,
        :position,
        :parent_type,
        :parent_id,
        :completion
      )
    end
end
