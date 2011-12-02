require 'TrackingLib'

class Package < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  
  has_many :items
  has_many :events
  
  validates :tracking_number, :uniqueness => true

  after_save :check_update_tracking

  def check_update_tracking
    if self.tracking_number
      update_tracking_information if Time.now - self.updated_at > 1.hour
    end
  end



  def status
    if pending?
      return "Pending"
    elsif shipped?
      return "Shipped"
    else
      return "Delivered"
    end
  end

  def ship_date_string
    ship_date ? ship_date.strftime("%d/%m") : 'N/A'
  end

  def estimated_delivery_date_string
    estimated_delivery_date ? estimated_delivery_date.strftime("%d/%m") : 'N/A'
  end

  def pending?
    ship_date == nil && delivered_at == nil
  end

  def shipped?
    ship_date != nil and delivered_at == nil
  end

  def delivered?
    delivered_at != nil
  end


  def for_user_token
    u = User.find_first_by_authentication_token(params[:token])
    if u
      @packages = u.packages
      respond_with @packages
    end
  end

  def update_tracking_information
    case Carrier.symbol_for_id(carrier_id)
    when :usps
      t = TrackingLib::USPS.new
    when :ups
      t = TrackingLib::UPS.new
    when :fedex
      t = TrackingLib::Fedex.new
    end
    t.track tracking_number
  end

  private
end
