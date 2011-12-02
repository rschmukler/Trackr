class EmailAddressesController < ApplicationController
  
  def create
    @email_address = EmailAddress.new(params[:email_address])
    @email_address.user = current_user
    if @email_address.save
      @success = true
      flash[:notice] = "Successfully saved Email Address. Go check it and validate it."
    else
      flash[:alert] = "Please make sure that the email address is valid and try again."
    end
    
    respond_to do |format|
      format.js {}
    end
  end
  
  def destroy
    @email_address = EmailAddress.find(params[:id])
    @email_address.destroy if @email_address
    flash[:notice] = "Successfully deleted email address" if @email_address
    flash[:alert] = "Oops something dun goofed." unless @email_address
    respond_to do |format|
      format.js
    end
  end
  
end