class PackagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @package = Package.new
    @packages = current_user.packages
    respond_with @packages
  end

  def show
    @package = Package.find(params[:id])
    if @package
      respond_with @package
    end
  end

end
