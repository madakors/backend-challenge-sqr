# frozen_string_literal: true

# Model for merchants table
class Merchant < ApplicationRecord
  has_many :disbursements
  has_many :orders
end
