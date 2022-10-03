# frozen_string_literal: true

# Class with rules for disbursements
class DisbursementRules
  # Return the disbursement for a given order
  # @param order [Order] an instance of the Order model
  # @return [BigDecimal] the disbursement amount
  def self.for_order(order)
    percentage = case order.amount
                 when 0...50
                   0.01
                 when 50..300
                   0.0095
                 else
                   0.0085 if order.amount > 300
                 end

    (order.amount * percentage).truncate(3)
  end
end
