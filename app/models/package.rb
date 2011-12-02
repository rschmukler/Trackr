require 'TrackingLib'

class Package < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  
  has_many :items
  has_many :events
  
  validates :tracking_number, :uniqueness => true



  def status
    if pending?
      return "Pending"
    elsif shipped
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
    ship_date == nil
  end

  def shipped?
    ship_date != nil and delivered_at == nil
  end

  def delivered?
    delivered_at != nil
  end

  def events
    case Carrier.symbol_for_id(carrier_id)
    when :usps then return usps_events
    when :ups then return ups_events
    when :fedex then return fedex_events
    end
  end

  def for_user_token
    u = User.find_first_by_authentication_token(params[:token])
    if u
      @packages = u.packages
      respond_with @packages
    end
  end

  def update_tracking
    
  end

  private

  def usps_events
    t = TrackingLib::USPS.new
    t.track self.tracking_number
    t.events
  end

  def ups_events
    t = TrackingLib::UPS.new
    t.track self.tracking_number
    t.events
  end

  def fedex_events
    t = TrackingLib::Fedex.new
    t.track self.tracking_number
    t.events
  end
end
