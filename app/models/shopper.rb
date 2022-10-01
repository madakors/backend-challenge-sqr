# frozen_string_literal: true

# Model for shoppers table
class Shopper < ApplicationRecord
  has_many :orders
end
