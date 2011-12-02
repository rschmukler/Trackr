class Package < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  
  has_many :items

  def status
    if pending?
      return "Pending"
    elsif shipped
      return "Shipped"
    else
      return "Delivered"
    end
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

  private

  def usps_events
    
  end

  def ups_events
    
  end

  def fedex_events
    
  end
end
