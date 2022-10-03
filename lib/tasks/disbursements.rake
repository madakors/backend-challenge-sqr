# frozen_string_literal: true

namespace :disbursements do
  task calculate: [:environment] do
    CalculateDisbursements.new.call
  end
end
