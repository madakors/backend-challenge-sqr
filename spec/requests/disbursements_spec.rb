# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Disbursements', type: :request do
  describe 'GET /disbursements' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let!(:disbursement_m1) { create(:disbursement, merchant: merchant1) }
    let!(:disbursement_m2) { create(:disbursement, merchant: merchant2) }
    let(:filters) { { merchant_id: merchant1.id } }

    it 'returns the searched disbursements' do
      get "/disbursements?merchant_id=#{merchant1.id}"

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match([disbursement_m1.as_json])
    end
  end
end
