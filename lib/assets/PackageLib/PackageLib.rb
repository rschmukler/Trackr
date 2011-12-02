require 'Parsers/VendorParser.rb'

module PackageLib
  class PackageLib
    def initialize(email)
      @email = email
      @vendor = self.find_vendor(email.subject_text)
      @parser = self.choose_parser
    end

    def create_package
      @parser.parse_text
      package = @parser.package
      package.save
    end


    def choose_parser
      #Code to check vendor
      if(@package.vendor)
        
      end
      case @vendor
      when 'Amazon'
        return AmazonParser.new(email.body_text)
      end
    end
  end
end
