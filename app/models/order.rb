# frozen_string_literal: true

# Model for orders table
class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :shopper

  scope :completed, -> { where.not(completed_at: nil) }
  scope :for_merchant, ->(merchant_id) { where(merchant_id: merchant_id) }
  scope :for_week, lambda { |year, week|
    where("DATE_PART('week', completed_at) = ?", week)
      .where("DATE_PART('year', completed_at) = ?", year)
  }

  # Return the weeks that have completed orders
  # @return [Array<Array<Integer, Integer>>] a list of weeks in the format of
  # [year, week], for instance: [[2022, 30], [2022, 31]]
  def self.weeks_and_years
    select("
           DATE_PART('week', completed_at) as \"week\",
           DATE_PART('year', completed_at) as \"year\"
           ").where.not(completed_at: nil)
      .group(2, 1)
      .order(2, 1).map { |order| [order.year.to_i, order.week.to_i] }
  end
end
