# frozen_string_literal: true

module OrdersService
  module NewOrder
    class Form
      # @param event [Hash]
      def initialize(event:)
        @event = event
      end

      # @return [Boolean]
      def valid? = result.success?

      # @return [Array<OrdersService::Validation::ErrorItem>]
      def errors = result.errors.messages.map { Validation::ErrorItem.parse(_1) }

      # @return [OrdersService::NewOrder::Order]
      def to_order
        OrdersService::Order.new(
          order_id: SecureRandom.uuid,
          customer_id: event.fetch(:customer_id),
          order_date: Time.now,
          status: Order::Status::PLACED,
          total: event.fetch(:total).to_i
        )
      end

      private

      # @return [Hash<Object, Object>]
      attr_reader :event

      # @return [Dry::Validation::Result]
      def result
        @result ||= Contract.new.call(
          customer_id: event.fetch(:customer_id, nil),
          total: event.fetch(:total, nil)
        )
      end
    end
  end
end
