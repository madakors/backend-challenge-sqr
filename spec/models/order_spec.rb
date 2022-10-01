# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  describe '.weeks_and_years' do
    subject(:result) { described_class.weeks_and_years }

    context 'when there are no completed orders' do
      before do
        create_list(:order, 2, completed_at: nil)
      end

      it 'return an empty array' do
        expect(result).to eq([])
      end
    end

    context 'when there are completed orders' do
      before do
        create(:order, completed_at: Time.new(2021, 8, 12))
        create(:order, completed_at: Time.new(2022, 9, 30))
      end

      it 'returns weeks and years of completed orders' do
        expect(result).to eq([[2021, 32], [2022, 39]])
      end
    end
  end

  describe '.for_week' do
    subject(:result) { described_class.for_week(*week) }

    context 'when there are no completed orders' do
      let(:week) { [2022, 39] }

      before do
        create(:order, completed_at: nil)
      end

      it 'returns an empty array' do
        expect(result).to eq([])
      end
    end

    context 'when there are orders for the given week' do
      let(:week) { [2022, 39] }
      let!(:orders) do
        [
          create(:order, completed_at: Time.new(2021, 8, 12)),
          create(:order, completed_at: Time.new(2022, 9, 30))
        ]
      end
      let(:expected_orders) { [orders.second] }

      it 'returns the expected orders' do
        expect(result).to eq(expected_orders)
      end
    end
  end
end
