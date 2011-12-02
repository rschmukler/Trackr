class EmailAddress < ActiveRecord::Base
  belongs_to :user

  validates :address, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  after_create :send_test_email, :unless => Proc.new{ self.confirmed == true }
  
  def primary?
    user.email == self.address
  end

  private

  def send_test_email
    self.generate_token
    #EmailConfirmation.confirmation_email(self).deliver
  end

  def generate_token
    self.token = ActiveSupper::SecureRandom.hex(4)
    self.save
  end
end
