# frozen_string_literal: true

# Model for disbursements table
class Disbursement < ApplicationRecord
  belongs_to :merchant

  def self.create_for_merchant(merchant, amount, year, week)
    upsert(
      { merchant_id: merchant, amount: amount, year: year, week: week },
      unique_by: %i[merchant_id week year]
    )
  end
end
