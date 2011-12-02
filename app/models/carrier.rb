class Carrier
  @@symbols = [:fedex, :ups, :usps]

  def id_for_symbol(symbol)
    @@symbols.index(symbol)
  end

  def symbol_for_id(id)
    @@symbols[id]
  end
end
