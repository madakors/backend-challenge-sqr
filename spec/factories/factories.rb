# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    amount { 250 }
    merchant
    shopper
  end
end

FactoryBot.define do
  factory :merchant do
    name { 'Merchant' }
    sequence :email
    cif { 'B611111111' }
  end
end

FactoryBot.define do
  factory :shopper do
    name { 'Happy Consumer' }
    sequence :email
    nif { '411111111Z' }
  end
end
