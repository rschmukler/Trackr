module PackageLib
  class VendorParser
    def initialize(text)
      @text = text
      @package = Package.where(:vendor => vendor, :order_number => order_number).first || Package.new
    end

    def package
      @package
    end

    def generate_orders
      order_numbers = get_order_numbers
      order_partial = @email.split(/Delivery estimate/)
      order_numbers.each do |on|
        email_address = @email.from_text.scan(/<[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._%+-]+>/)
        u_id = User.find_by_email_possesion(email_address)
        if u_id
          order = Order.new(:order_date => @email.sent_at, :vendor_id => Vender.id_for_string(@vendor), :order_number => on, :user_id => u_id)
          if not order.save
            #TODO: Toss an email to the user notifying them something went wrong.
          end
          generate_package_for_order_text(order,order_partial[i])
          i = i + 1 #increment order partial 
        end
      end
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
