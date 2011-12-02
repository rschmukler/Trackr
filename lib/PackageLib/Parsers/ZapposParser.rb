module PackageLib
  class VendorParser
  end

  class ZapposParser < VendorParser
    
    def initialize(email)
      @vendor = 'Zappos'
      super(email)
      #Strip extra stuff of body
      @email.body_text.gsub!(/<.*\n.*\n.*>|<.*\n.*>|\[image:\n.*\]|\[image:.*\]|\[image:.*\n.*\]/,"")
    end
    
    def is_updating_an_order?
      if(@text =~ /being shipped/)
        return true
      end
      return false
    end
    
    def generate_orders
      order_numbers = get_order_numbers
      order_partial = @email.body_text.split(/Order Reference Number:/)[1..-1]
      i = 0
      order_numbers.each do |on|
        email_address = @email.from_text.scan(/<[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._%+-]+>/).first[1..-2]
        puts email_address.class
        @user = User.find_by_email_possesion(email_address)
        if @user
          order = Order.new(:order_date => @email.created_at, :vendor_id => Vendor.id_for_string(@vendor), :order_number => on, :user_id => @user.id)
          if not order.save
            #TODO: Toss an email to the user notifying them something went wrong.
          end
          generate_package_for_order_text(order,order_partial[i])
          i = i + 1 #increment order partial 
        end
      end
    end
    
    def generate_package_for_order_text(order,text)
      items = get_items(text)
      package_name = items.map{|item| item[:name]}.join(" and ")
      #Create a new package
      package = Package.new(:name => package_name)
      package.user = @user
      package.order = order
      package.vendor_id = Vendor.id_for_string(@vendor)
      package.save
      #Add items
      puts items
      items.each do |itemHashObject|
        itemHashObject.merge!(:package_id => package.id)
        item = Item.create!(itemHashObject)
        item = package
        item.save
      end
    end
     
    def update_orders
      right_order = nil
      Order.where(:vendor_id => Vendor.id_for_string(@vendor), :order_number => get_order_numbers.first).first.packages.each do |package|
        package.items.each do |item|
          right_order = package if not @text.scan(item.name).empty?
        end
      end

      if right_order
        right_order.carrier_id = Carrier.id_for_symbol(get_package_carrier)
        tn = get_tracking_number
        right_order.tracking_number = tn.first
        right_order.save
      end

    end
    private

    def get_items(text)
      items =[]
      item_strs = text.scan(/mary:.*\n.*\n.*\n.*\nSKU|mary:.*\n.*\n.*\nSKU/)
      item_strs.map!{|item_str| item_str.gsub!(/\n/, " ")}
      puts item_strs
      item_strs.each do |item|
        item = item.split(/ \"/) #Matches the first item with package
        items << {:name => item.last[0..-2], :count => 1}
      end
     items
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
      case get_package_carrier
      when :ups
        tracking_number = @text.scan(/1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\\d\\d\\d ?\\d\\d\\d\\d ?\\d\\d\\d/)
      when :fedex
        tracking_number = @text.scan(/\b96\d{20}\b|\b\d{15}\b|\b\d{12}\b/)
      when :usps
        tracking_number = @text.scan(/\b(91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d|91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d)\b/)
      end
      tracking_number
    end
    
    def get_order_numbers
      return @text.scan(/[0-9]{9}/)
    end
    
    def shipped?
      if(@test =~ /shipped\. YAY/)
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
