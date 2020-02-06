require_relative 'shop'

# Checkout module
class Checkout
  attr_accessor :cart, :pricing_rules, :total

  def initialize(pricing_rules)
    self.pricing_rules = pricing_rules
    self.cart = Cart.new
    self.total = 0
  end

  def total_price
    calculate_total(checkout_offers)
  end

  def scan(product)
    cart.add_product(product)
    cal_price
  end

  class << self
    def checkout(product_codes=nil)
      co = Checkout.new(Offer.pricing_rules)
      codes = product_codes || %w[FR FR]
      codes.each { |code| co.scan(Product.find_by_code(code)) }
      co.total_price
    end
  end

  private

  def offer_discount(offers)
    offers.map(&:discount).reduce(&:+)
  end

  def calculate_total(offers)
    return total unless offers.any?

    self.total -= total * offer_discount(offers) / 100.00
  end

  def checkout_offers
    pricing_rules.select { |rule| rule.amount_offer_applied?(total) }
  end

  def cal_price
    self.total = cart_products_price.sum
  end

  def match_rules(product_code, frequency)
    Offer.applied_offers(product_code, frequency)
  end

  def match_rules?(product_code, frequency)
    match_rules(product_code, frequency).any?
  end

  def product_price(price, frequency)
    price * frequency
  end

  def product_offer_price(price, frequency, rule = nil)
    discount = rule&.discount || 0
    ((price / 100.0) * (100.0 - discount)) * frequency
  end

  def total_product_price(price, frequency, rule = nil)
    without_offer = frequency % (rule&.factor || 1)
    with_offer = frequency - without_offer

    product_price(price, without_offer) +
      product_offer_price(price, with_offer, rule)
  end

  def offer_price(product, frequency)
    price = total_product_price(product.price, frequency)
    return price unless match_rules?(product.code, frequency)

    match_rules_price(product, frequency).sum
  end

  private
  def match_rules_price(product, frequency)
    match_rules(product.code, frequency).collect do |rule|
      total_product_price(product.price, frequency, rule) || 0
    end
  end

  def cart_products_price
    cart.products.collect do |info|
      offer_price(info[:product], info[:frequency])
    end
  end

end

result = Checkout.checkout
puts "Total payable amount: #{result}"
