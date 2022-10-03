# frozen_string_literal: true

# Model for disbursements table
class Disbursement < ApplicationRecord
  belongs_to :merchant

  # Create or update a disbursment record for a given <merchant, year, week> touple
  # @param merchant [Integer] a valid Merchant ID
  # @param amount [BigDecimal] the amount of the disbursment
  # @param year [Integer] the year of the week
  # @param week [Integer] the week number of the week
  # @return [Disbursement] the created or updated disbursment record
  def self.create_for_merchant(merchant, amount, year, week)
    upsert(
      { merchant_id: merchant, amount: amount, year: year, week: week },
      unique_by: %i[merchant_id week year]
    )
  end
end
