# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementSearch do
  subject(:search_result) { described_class.new(params).call }

  let(:params) { ActionController::Parameters.new(filters) }
  let(:filters) { {} }

  context 'when there are no disbursements' do
    it 'returns an empty array' do
      expect(search_result).to eq([])
    end
  end

  context 'when searching for a specific merchant' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let!(:disbursement_m1) { create(:disbursement, merchant: merchant1) }
    let!(:disbursement_m2) { create(:disbursement, merchant: merchant2) }
    let(:filters) { { merchant_id: merchant1.id } }

    it "returns that merchant's disbursements" do
      expect(search_result).to eq([disbursement_m1])
    end
  end

  context 'when no merchant given' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let!(:disbursement_m1) { create(:disbursement, merchant: merchant1) }
    let!(:disbursement_m2) { create(:disbursement, merchant: merchant2) }
    let(:filters) { { week: 1, year: 2022 } }

    it 'returns every disbursement' do
      expect(search_result).to eq([disbursement_m1, disbursement_m2])
    end
  end

  context 'when searching for merchant and week' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let!(:disbursement_m1) { create(:disbursement, merchant: merchant1) }
    let!(:disbursement_m21) { create(:disbursement, week: 1, year: 2022, merchant: merchant2) }
    let!(:disbursement_m22) { create(:disbursement, week: 2, year: 2022, merchant: merchant2) }
    let(:filters) { { week: 1, year: 2022, merchant_id: merchant2.id } }

    it 'returns every disbursement' do
      expect(search_result).to eq([disbursement_m21])
    end
  end
end
