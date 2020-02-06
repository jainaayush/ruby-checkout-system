# Offer module for sales
class Offer
  attr_reader :factor, :category, :product_code, :discount

  # We can set this as dynamic as well by setting up a new table for the same.
  def initialize(factor, category, product_code, discount)
    @factor = factor
    @category = category
    @product_code = product_code
    @discount = discount
  end

  def amount_offer_applied?(total)
    category == :amount && factor <= total
  end

  def product_offer_applied?(code)
    product_code == code
  end

  class << self
    def pricing_rules
      @pricing_rules = [
        new(2, :bogof, 'FR', 50), # Buy one get one free
        new(3, :cpi, 'AP', 10), # Cost per item reduce
        new(60, :amount, nil, 20)
      ]
    end

    def applied_offers(product_code, frequency)
      pricing_rules.select do |rule|
        rule.product_code == product_code &&
          rule.factor <= frequency
      end
    end
  end
end
