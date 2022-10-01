# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementRules do
  describe '.for_order' do
    subject(:disbursement) { described_class.for_order(order) }

    let(:order) { build_stubbed(:order, amount: amount) }

    context 'when amount is smaller than 50' do
      context 'when amount is 0' do
        let(:amount) { 0 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(0)
        end
      end

      context 'when amount is 25' do
        let(:amount) { 25.0 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(0.25)
        end
      end

      context 'when amount is 49.99' do
        let(:amount) { 49.99 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(0.499)
        end
      end
    end

    context 'when amount is between 50 and 300' do
      context 'when amount is 50' do
        let(:amount) { 50 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(0.475)
        end
      end

      context 'when amount is 253.3' do
        let(:amount) { 253.3 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(2.406)
        end
      end

      context 'when amount is 300' do
        let(:amount) { 300 }

        it 'returns the disbursement amount' do
          expect(disbursement).to eq(2.85)
        end
      end
    end

    context 'when amount is larger than 300' do
      let(:amount) { 5000 }

      it 'returns the disbursement amount' do
        expect(disbursement).to eq(42.5)
      end
    end
  end
end
