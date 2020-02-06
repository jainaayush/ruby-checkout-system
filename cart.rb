require_relative 'product'

# Cart module
class Cart
  attr_reader :products

  def initialize
    @products = []
  end

  def add_product(product)
    product_hash = products_by_code(product.code).first
    if product_hash
      increse_product_frequency(product_hash)
    else
      add_first_product(product)
    end
  end

  def products_by_code(product_code)
    products.select{ |product| product[:product].code == product_code }
  end

  def grand_total
    products.collect{ |product| product[:product].price}.sum
  end

  def to_json(*_args)
    JSON.dump(products: products.collect { |product| product[:product] })
  end

  private

  def add_first_product(product)
    products << { product: product, frequency: 1 }
  end

  def increse_product_frequency(product_hash)
    product_hash.merge!(frequency: product_hash[:frequency] + 1)
  end

  def product_frequency(product_code)
    products_by_code(product_code)&.length
  end
end
