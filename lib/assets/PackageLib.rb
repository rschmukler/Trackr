require "#{Rails.root}/lib/assets/PackageLib/Parsers/VendorParser.rb"

module PackageLib
  class PackageLib
    def initialize(email)
      #Find order first
      @email = email
      @vendor = self.find_vendor
      @parser = self.choose_parser
    end
    
    def fill_orders
      if @parser.is_updating_an_order?
        @parser.update_orders
      else
        @parser.generate_orders
      end
    end

    def save_orders
      @orders.each do |order|
        order.save
      end 
    end

    def find_vendor
      return @email.subject_text.scan(/Amazon|Newegg/).first
    end

    def handle_email
      parse_orders

    end
    
    def parse_orders
      orders = []
      @order_numbers = find_order_numbers
      vendor = Vender.id_for_string(@vendor)
      @order_numbers.each do |order_number|
        order = Order.where(:vendor => @vendor, :order_number => order_number).first || Order.new
        
        orders = fill_order(email)
      end
      return orders
    end
    
    def find_order_numbers
      
    end
    def choose_parser
      case @vendor
      when "Amazon"
        return AmazonParser.new(@email)
      when "Newegg"
        return NeweggParser.new(@email)
      end
    end
  end
end