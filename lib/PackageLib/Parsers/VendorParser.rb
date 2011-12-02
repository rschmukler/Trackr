require_relative "./AmazonParser.rb"
require_relative "./NeweggParser.rb"
require_relative "./MicrosoftParser.rb"
require_relative "./ZapposParser.rb"

module PackageLib
  class VendorParser
    def initialize(email)
      @email = email
      @text = email.body_text
    end

    def package
      @package
    end

    
    def parse_text
      if(self.shipped?)
        @package.tracking_number = self.get_tracking_number
        @package.carrier = self.get_package_carrier
      end
      @package.items = self.get_items
      @package.order_number = self.get_order_number 
      @package.get_estimated = self.get_estimated
    end
  end
end
