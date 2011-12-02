module PackageLib
  class VendorParser
    def initialize(text)
      @text = text
      @package = Package.new
    end

    def package
      @package
    end

    def parse_text
      @package.carrier = self.get_package_carrier
      @package.tracking_number = self.get_tracking_number
    end
  end
end
