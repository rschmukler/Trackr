class EmailController < ApplicationController
  def create
    mail = Email.new
    mail.from_text = params[:from]
    mail.subject_text = params[:subject]
    mail.body_text = params['body-plain']
    mail.save
    redirect_to root_path
  end
end
