class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    mail = Email.new
    mail.from_text = params[:from]
    mail.subject_text = params[:subject]
    mail.body_text = params['body-plain']
    mail.save
    redirect_to root_path
  end
end
