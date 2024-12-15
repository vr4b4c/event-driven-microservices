# frozen_string_literal: true

RSpec.describe Function do
  let(:ctx) { {} }
  let(:event) { { 'body' => JSON.generate(order_data) } }

  context 'when event contains valid data' do
    let(:order_data) { { 'customer_id' => '0xFF', 'total' => 10 } }

    it 'responds with successs' do
      result = described_class.perform(event:, context: ctx)
      expect(result[:statusCode]).to eq(200)
    end
  end

  context 'when event contains invalid data' do
    let(:order_data) { { 'customer_id' => '0xFF', 'total' => -5 } }

    it 'responds with failure' do
      result = described_class.perform(event:, context: ctx)

      expect(result[:statusCode]).to eq(400)
    end
  end
end
