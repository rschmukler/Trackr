class Order < ActiveRecord::Base
  has_many :packages
  belongs_to :user

  class << self
    def fill_orders_from_email(email)
      lib = PackageLib::PackageLib.new(email)
      lib.fill_orders
    end
  end
  
end
