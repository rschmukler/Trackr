module PackageLib
  class AmazonParser < VendorParser
    
    def initialize(text)
      @vendor = 'Amazon'
      super(text)
    end
    
    def is_updating_an_order?
      if(@test =~ /being shipped/)
        return true
      end
      return false
    end
    
    def generate_package_for_order_text(order,text)
      package = Package.new
      package.order = order
      items = self.get_items
      package_name = items.map{|item| item[:name]}.join(" and ")
      #Create a new package
      package = Package.new(:name => package_name)
      package.save
      #Add items
      items.each do |itemHashObject|
        itemHashObject.merge!(:package_id => package.id)
        item = Item.create!(itemHashObject)
        item = package
        item.save
      end
    end
     
    def update_orders
      self.get_package_carrier
      Order.where(:vendor => @vendor, :order_number => self.get_order_numbers.first).first.packages.each do |package|
        unless package.items.find_by_name(name).nil?
          package.carrier_id = Carrier.id_for_symbol(get_package_carrier)
          package.tracking_number = get_tracking_number
          package.save
        end
      end
      
      self.get_tracking_number
    end
    private

    def get_items(text)
      item_strs = text.scan(/[0-9]+ \"[0-z .\-@#\/\,]*\"/)
      item_strs.each do |item|
        item = self.get_items.first.split(/ /) #Matches the first item with package
        items << {:name => item.last[1,-1], :count => item.first}
      end
    end
    
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
      if(@test =~ /being shipped/)
        return true
      end
      return false
    end
    
    def get_estimated
      date_str = @text.scan(/(Janurary|Feburary|March|April|May|June|July|August|September|October|November|December)\s([0-9][0-9]|[0-9]), [0-9]{4}/)
      return Date.strptime(date_str, '%h %d, %Y')
    end
  end
end