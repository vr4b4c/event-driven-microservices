# frozen_string_literal: true

module OrdersService
  module CreateOrder
    class Result
      # @return [OrdersService::Order, nil]
      attr_reader :order

      # @param form [OrdersService::CreateOrder::Form]
      # @param order [OrdersService::Order, nil]
      def initialize(form:, order: nil)
        @form = form
        @order = order
      end

      # @return [Boolean]
      def success? = form.valid?

      # @return [Array<OrdersService::Validation::ErrorItem>]
      def errors = form.errors

      private

      # @return [OrdersService::CreateOrder::Form]
      attr_reader :form
    end
  end
end
