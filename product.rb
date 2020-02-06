# Product module for sales
class Product
  attr_reader :code, :name, :price

  class << self
    def products
      @products ||= [
        new('FR', 'Fruit tea', 3.11),
        new('AP', 'Apple', 5.00),
        new('CF', 'Coffee', 11.23)
      ]
    end

    def find_by_code(code)
      products.detect { |prod| prod.code == code }
    end
  end

  # We can set this as dynamic as well by setting up a new table for the same.
  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end
end
