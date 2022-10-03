# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateDisbursements do
  subject(:calculation) { described_class.new }

  context 'when there are no completed orders' do
    let(:merchant) { create(:merchant) }
    before do
      create_list(:order, 2, merchant: merchant, completed_at: nil)
    end

    it "doesn't create disbursements" do
      expect { calculation.call }.to_not(change { Disbursement.count })
    end
  end

  context 'when there is one completed order' do
    let(:merchant) { create(:merchant) }
    let(:order) { create(:order, merchant: merchant, amount: 50, completed_at: DateTime.new(2022, 9, 30)) }
    let!(:expected_disbursement_amount) { DisbursementRules.for_order(order) }

    it 'creates one disbursement' do
      expect { calculation.call }.to change { Disbursement.count }.by(1)
    end

    it 'calculates disbursement correctly' do
      calculation.call
      expect(merchant.reload.disbursements.first.reload.amount).to eq(expected_disbursement_amount)
    end
  end

  context 'when a merchant has multiple completed orders for a week' do
    let(:merchant) { create(:merchant) }
    let(:order1) { create(:order, merchant: merchant, amount: 50, completed_at: DateTime.new(2022, 9, 29)) }
    let(:order2) { create(:order, merchant: merchant, amount: 150, completed_at: DateTime.new(2022, 9, 30)) }
    let!(:expected_disbursement_amount) { DisbursementRules.for_order(order1) + DisbursementRules.for_order(order2) }

    it 'creates one disbursement' do
      expect { calculation.call }.to change { Disbursement.count }.by(1)
    end

    it 'calculates disbursement correctly' do
      calculation.call
      expect(merchant.reload.disbursements.first.reload.amount).to eq(expected_disbursement_amount)
    end
  end

  context 'when mulitple merchants have multiple orders for multiple weeks' do
    let(:merchant1) { create(:merchant) }
    let(:merchant2) { create(:merchant) }
    let(:order_m11) { create(:order, merchant: merchant1, amount: 50, completed_at: DateTime.new(2022, 9, 1)) }
    let(:order_m12) { create(:order, merchant: merchant1, amount: 50, completed_at: DateTime.new(2022, 9, 2)) }
    let(:order_m13) { create(:order, merchant: merchant1, amount: 50, completed_at: DateTime.new(2022, 9, 10)) }
    let(:order_m21) { create(:order, merchant: merchant2, amount: 50, completed_at: DateTime.new(2022, 8, 1)) }
    let(:order_m22) { create(:order, merchant: merchant2, amount: 50, completed_at: DateTime.new(2022, 8, 10)) }

    let!(:expected_disbursement_m1_w1) do
      DisbursementRules.for_order(order_m11) + DisbursementRules.for_order(order_m12)
    end
    let!(:expected_disbursement_m1_w2) { DisbursementRules.for_order(order_m13) }
    let!(:expected_disbursement_m2_w1) { DisbursementRules.for_order(order_m21) }
    let!(:expected_disbursement_m2_w2) { DisbursementRules.for_order(order_m22) }

    it 'creates four disbursements' do
      expect { calculation.call }.to change { Disbursement.count }.by(4)
    end

    it 'calculates disbursements correctly' do
      calculation.call
      expect(merchant1.disbursements.count).to eq(2)
      expect(merchant1.disbursements.map(&:amount)).to eq([expected_disbursement_m1_w1, expected_disbursement_m1_w2])

      expect(merchant2.disbursements.count).to eq(2)
      expect(merchant2.disbursements.map(&:amount)).to eq([expected_disbursement_m2_w1, expected_disbursement_m2_w2])
    end
  end
end
