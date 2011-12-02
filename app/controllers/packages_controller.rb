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
      respond_with @package.to_json(:include =>[:items, :events])
    end
  end
  
  def create
    @package = Package.new(params[:package])
    @package.user = current_user
    if @package.save
      @success = true
      flash[:notice] = 'Package successfully added'
    else
      flash[:alert] = 'Something dun goofed. Try again'
    end
    respond_to do |f|
      f.js
    end
  end

  def update_tracking
    @package = Package.find(params[:id])
    Resque.enqueue(Tracking, @package)
  end
  
  def destroy
    @package = Package.find(params[:id])
    @package.destroy if @package
  end

  def for_token
    u = User.where(:authentication_token => params[:token]).first
    if u
      respond_with u.packages
    end
  end

end
