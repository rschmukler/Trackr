class Vendor
  @@vendors = ["Amazon", "Microsoft Store", "Zappos"]

  class << self
    def string_for_id(id)
      @@vendors[id]
    end
    
    def vendors
      @@vendors
    end
    

    def vendors_array
      index = 0
      to_return = []
      @@vendors.each do |val|
        to_return << [val, index]
        index += 1
      end
    end

    def id_for_string(string)
      @@vendors.index(string)
    end
  end
end
