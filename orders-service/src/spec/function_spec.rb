# frozen_string_literal: true

RSpec.describe Function do
  let(:ctx) { {} }

  context 'when event contains valid data' do
    let(:event) { { 'customer_id' => '0xFF', 'total' => 10 } }

    it 'responds with successs' do
      result = described_class.perform(event:, context: ctx)
      expect(result[:status]).to eq(:success)
    end
  end

  context 'when event contains invalid data' do
    let(:event) { { 'customer_id' => '0xFF', 'total' => -5 } }

    it 'responds with failure' do
      result = described_class.perform(event:, context: ctx)

      expect(result[:status]).to eq(:failure)
    end
  end
end
