# frozen_string_literal: true

RSpec.shared_context 'products' do
  let(:fruit_tea) do
    Product.new(
      'FR',
      'Fruit tea',
      3.11
    )
  end

  let(:apple) do
    Product.new(
      'AP',
      'Apple',
      3.11
    )
  end

  let(:coffee) do
    Product.new(
      'CF',
      'Coffee',
      11.23
    )
  end

  let(:products) { [apple, coffee, fruit_tea] }
end
