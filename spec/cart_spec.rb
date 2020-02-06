require './cart'
require 'shared/product'

RSpec.describe Cart do
  include_context 'products'

  describe 'Cart module and methods' do

    let(:cart) { Cart.new }

    before do
      cart.add_product(fruit_tea)
      cart.add_product(apple)
      cart.add_product(coffee)
    end

    it 'return the total price of scanned products' do
      expect(cart.grand_total).to eq(17.45)
    end

    it 'return fruit tea item code not empty' do
      expect(cart.products_by_code('FR')).not_to be_empty
    end

    it 'return blank response on random product code' do
      expect(cart.products_by_code('FT')).to be_empty
    end
  end
end
