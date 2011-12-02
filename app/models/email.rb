require 'PackageLib'

class Email < ActiveRecord::Base
  validates :from_text, :presence => true
  validates :body_text, :presence => true
  validates :subject_text, :presence => true

  after_create :parse_email
  
  def parse_email
    lib = PackageLib::PackageLib.new(self)
    lib.fill_orders
  end
end
