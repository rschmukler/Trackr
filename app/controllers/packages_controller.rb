class PackagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @package = Package.new
    @packages = current_user.packages
  end

end
