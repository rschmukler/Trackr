class SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @email_address = EmailAddress.new
  end

end
