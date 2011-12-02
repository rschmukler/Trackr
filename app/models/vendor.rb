class Vendor
  @@vendors = ["Amazon", "Microsoft Store", "Zappos"]

  class << self
    def string_for_id(id)
      @@vendors[id - 1]
    end
    
    def vendors
      @@vendors
    end
    
    def vendor_ids
      @@vendors = [1, 2, 3]
    end
    
    def vendors_array
      index = 1
      to_return = []
      @@vendors.each do |val|
        to_return << [val, index]
        index += 1
      end
    end

    def id_for_string(string)
      @@vendors.index(string) + 1
    end
  end
end
