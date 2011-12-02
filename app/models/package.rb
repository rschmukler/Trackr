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
    shipped_at == nil
  end

  def shipped?
    shipped_at != nil and delivered_at == nil
  end

  def delivered?
    delivered_at != nil
  end
end
