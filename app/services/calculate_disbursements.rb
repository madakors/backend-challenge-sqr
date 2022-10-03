# frozen_string_literal: true

# Class that calculates and persists disbursements for merchants
class CalculateDisbursements
  # Calculate disbursements for a given week(s) or all weeks
  # @param weeks [Array<Array<Integer, Integer>>] a list of weeks in the format
  # of [year, week], for instance: [[2022, 30], [2022, 31]]
  def call(weeks = every_week)
    merchants.each do |merchant|
      weeks.each do |week|
        calculate_disbursements(merchant, week)
      end
    end
  end

  private

  def calculate_disbursements(merchant, week)
    disbursement_amount = 0
    Order.completed.for_week(*week).for_merchant(merchant).each do |order|
      disbursement_amount += DisbursementRules.for_order(order)
    end
    return if disbursement_amount.zero?

    Disbursement.create_for_merchant(merchant, disbursement_amount, *week)
  end

  def every_week
    Order.weeks_and_years
  end

  def merchants
    @merchants ||= Merchant.pluck(:id)
  end
end
