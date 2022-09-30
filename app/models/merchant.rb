class Merchant < ApplicationRecord
  has_many :disbursements
  has_many :orders
end
