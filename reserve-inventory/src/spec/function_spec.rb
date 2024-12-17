# frozen_string_literal: true

RSpec.describe Function do
  let(:ctx) { {} }
  let(:event) { { 'Records' => [{ 'body' => JSON.generate(order_data) }] } }

  context 'when event contains valid data' do
    let(:order_data) { { 'order_id' => 'a12b34', 'customer_id' => '0xFF', 'total' => 10 } }

    it "doesn't raise error" do
      expect do
        described_class.perform(event:, context: ctx)
      end.not_to raise_error
    end
  end
end
