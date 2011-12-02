class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :email_addresses, :conditions => ['confirmed = ?', true]
  has_many :orders
  has_many :packages

  after_create :claim_email_address


  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.find_by_email(data.email)
      user
    else # Create a user with a stub password. 
      User.create!(:email => data.email, :encrypted_password => Devise.friendly_token[0,20]) 
    end
  end

  def claim_email_address
    EmailAddress.create!(:address => self.email, :user_id => self, :confirmed => true)
  end
end
