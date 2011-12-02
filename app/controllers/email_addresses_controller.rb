class EmailAddressesController < ApplicationController
  def create
    @email_address = EmailAddress.new(params[:email_address])
    @email_address.user = current_user
    if @email_address.save
      flash[:notice] = "Successfully saved Email Address. Go check it and validate it."
    else
      flash[:alert] = "Please make sure that the email address is valid and try again."
    end
  end
end