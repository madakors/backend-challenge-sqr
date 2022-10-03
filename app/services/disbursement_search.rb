# frozen_string_literal: true

# Class for handling disbursement search logic
class DisbursementSearch
  # @param params [ActionController::Parameters] parameters for the search
  def initialize(params)
    @params = params
  end

  # Execute search and get disbursements based on parameters. If a merchant ID isn't
  # given, it returns every disbursement
  # @return [Array<Disbursement>] a list of disbursements
  def call
    return all_disbursements if merchant_missing?

    Disbursement.where(whitelisted_params)
  end

  private

  def all_disbursements
    Disbursement.all
  end

  def whitelisted_params
    @params.permit(:merchant_id, :year, :week)
  end

  def merchant_missing?
    !@params.key?(:merchant_id)
  end
end
