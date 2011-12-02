class Vendor
  @@vendors = ["Amazon"]

  class << self
    def string_for_id(id)
      @@vendors[id - 1]
    end

    def id_for_string(string)
      @@vendors.index(string) + 1
    end
  end
end
