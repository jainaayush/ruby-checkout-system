require './checkout'
require 'shared/product'

RSpec.describe Checkout do
  include_context 'products'

  describe 'Checkout System' do

    it 'return amount after by one get one free offer' do
      response = Checkout.checkout(['FR', 'FR'])
      expect(response).to eql(3.11)
    end

    it 'return total of apple as price reduce by each item offer' do
      response = Checkout.checkout(['AP', 'AP', 'AP'])
      expect(response).to eql(13.50)
    end

    it 'return total after multiple offer' do
      response = Checkout.checkout(['FR', 'AP', 'CF', 'AP', 'AP'])
      expect(response).to eql(27.84)
    end
  end
end
