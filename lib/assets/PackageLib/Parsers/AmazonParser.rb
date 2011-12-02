module PackageLib
  class AmazonParser < VendorParser


    private

    def get_package_carrier
      if(@text =~ /UPS/)
        return 'UPS'
      end
      if(@text =~ /USPS/)
        return 'USPS'
      end
      if(@text =~ /Fedex/)
        return 'Fedex'
      end
    end
    
    def get_package_carrier
      case @vendor
      when 'UPS'
        @tracking_number = @text.scan(/1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\\d\\d\\d ?\\d\\d\\d\\d ?\\d\\d\\d/)
        break
      when 'Fedex'
        @tracking_number = @text.scan(/(\b96\d{20}\b)|(\b\d{15}\b)|(\b\d{12}\b)/)
        break
      when 'USPS'
        @tracking_number = @text.scan(/\b(91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d|91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d)\b/)
      end
    end
    
    def get_order_number
      return @text.scan(/[0-9]{3}-[0-9]{7}-[0-9]{7}/)
    end
    
    def is_shipped
      if(@test =~ /Shipped/)
        return true
      end
      return false
    end
  end
end