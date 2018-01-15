class SitesController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized
  
  # GET /sites
  def index
    authorize! :read, Site
    @sites = Site.accessible_by(current_ability)
    render json: @sites
  end
  
  protected
  
  def not_authorized
    head :forbidden
  end
end
