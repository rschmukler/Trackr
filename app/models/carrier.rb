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
  end
end
