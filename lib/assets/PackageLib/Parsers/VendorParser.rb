module PackageLib
  class VendorParser
    def initialize(text)
      @text = text
      @package = Package.where(:vendor => vendor, :order_number => order_number).first || Package.new
    end

    def package
      @package
    end

    def parse_text
      if(self.is_shipped)
        @package.tracking_number = self.get_tracking_number
        @package.carrier = self.get_package_carrier
      end
      @package.items = self.get_items
      @package.order_number = self.get_order_number 
      @package.get_estimated = self.get_estimated
    end
  end
end
