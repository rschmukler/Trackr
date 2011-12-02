class Carrier
  @@symbols = [:fedex, :ups, :usps]
  @@strings = ["Fedex", "UPS", "USPS"]

  class << self
    def id_for_symbol(symbol)
      @@symbols.index(symbol)
    end

    def symbol_for_id(id)
      id ? @@symbols[id] : :unknown
    end

    def string_for_id(id)
      id ? @@strings[id] : 'Unknown'
    end
    
    def carriers_array
      index = 0
      to_return = []
      @@strings.each do |string|
        to_return << [string, index]
        index +=1
      end
      to_return
    end
  end
end
