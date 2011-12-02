require_relative "./AmazonParser.rb"

module PackageLib
  class VendorParser
    def initialize(email)
      @email = email
      @text = email.body_text
    end

    def package
      @package
    end

    def generate_orders
      order_numbers = get_order_numbers
      order_partial = @email.body_text.split(/Delivery estimate/)[1..-1]
      puts "Order Numbers: #{order_numbers}"
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
