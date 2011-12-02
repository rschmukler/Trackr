module PackageLib
  class AmazonParser < VendorParser
    
    def is_updating_an_order?
      #Insert some regex
    end
    
    def generate_orders
      order_numbers = get_order_numbers
      order_numbers.each do |on|
        email_address = @email.from_text #parse out stuff not in brackets
        u_id = User.find_by_email_possesion(email_address)
        if u_id
          o = Order.new(:order_date => @email.sent_at, :vendor => 'Amazon', :order_number => on, :user_id => u_id)
          generate_packages_for_order(o)
          if not o.save
            #TODO: Toss an email to the user notifying them something went wrong.
          end
        end
      end
    end
    
    def generate_packages_for_order(o)
      text = text_for_order_number(o.order_number)
      generate_packages_for_order_text(o, text)
    end
    
    def text_for_order_number
      
    end
    
    def fill
      
    end

     
    private

    def get_package_carrier
      if(@text =~ /UPS/)
        return :ups
      end
      if(@text =~ /USPS/)
        return :usps
      end
      if(@text =~ /Fedex/)
        return :fedex
      end
    end
    
    def get_tracking_number
      case @vendor
      when :ups
        @tracking_number = @text.scan(/1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\\d\\d\\d ?\\d\\d\\d\\d ?\\d\\d\\d/)
        break
      when :fedex
        @tracking_number = @text.scan(/(\b96\d{20}\b)|(\b\d{15}\b)|(\b\d{12}\b)/)
        break
      when :usps
        @tracking_number = @text.scan(/\b(91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d|91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d)\b/)
      end
    end
    
    def get_order_numbers
      return @text.scan(/[0-9]{3}-[0-9]{7}-[0-9]{7}/)
    end
    
    def shipped?
      if(@test =~ /Shipped/)
        return true
      end
      return false
    end
    
    def get_estimated
      return @text.scan(/(Janurary|Feburary|March|April|May|June|July|August|September|October|November|December)\s([0-9][0-9]|[0-9]), [0-9]{4}/)
      
    end
  end
end