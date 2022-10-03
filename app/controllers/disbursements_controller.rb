# frozen_string_literal: true

# Controller for disbursements
class DisbursementsController < ApplicationController
  def index
    result = DisbursementSearch.new(params).call
    render json: result
  end
end
