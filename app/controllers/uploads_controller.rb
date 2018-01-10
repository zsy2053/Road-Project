class UploadsController < ApplicationController
  before_action :authenticate_request!

  before_action :set_upload, only: [:show, :update, :destroy]

  # GET /uploads
  def index
    @uploads = Upload.accessible_by(current_ability)

    render json: @uploads
  end

  # GET /uploads/1
  def show
    render json: @upload
  end

  # POST /uploads
  def create
    @upload = Upload.new(upload_params)
    @upload.user = current_user

    if @upload.save
      @upload.signed_url = get_signed_put_url(@upload, 15.minutes)
      render json: @upload, status: :created, location: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /uploads/1
  def update
    if @upload.update(upload_params)
      render json: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  # DELETE /uploads/1
  def destroy
    @upload.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def upload_params
      params.require(:upload).permit(:filename, :content_type, :category)
    end
    
    # Generate temporary signed PUT URL during create step
    def get_signed_put_url(upload, duration)
      # use Fog config
      storage = Fog::Storage.new(Rails.configuration.x.fog_configuration)
      
      # set request attributes
      headers = { "Content-Type" => upload.content_type }
      options = { "path_style" => "true" }
      
      # generate signed url
      return storage.put_object_url(
        ENV['S3_BUCKET_NAME'],
        upload.path,
        duration.from_now.to_time.to_i,
        headers,
        options
      )
    end
end
