# frozen_string_literal: true

module OrdersService
  class Order
    class Status
      ALL = [PLACED = :placed].freeze
    end

    # @return [String]
    attr_reader :order_id

    # @return [String]
    attr_reader :customer_id

    # @return [Date]
    attr_reader :order_date

    # @return [Symbol]
    attr_reader :status

    # @return [Integer]
    attr_reader :total

    # @param order_id [String]
    # @param customer_id [String]
    # @param order_date [Date]
    # @param status [Symbol]
    # @param total [Integer]
    def initialize(**opts)
      @order_id = opts.fetch(:order_id)
      @customer_id = opts.fetch(:customer_id)
      @order_date = opts.fetch(:order_date)
      @status = opts.fetch(:status)
      @total = opts.fetch(:total)
    end

    # @return [Hash<Symbol, Object>]
    def to_dynamo_item
      { order_id:, customer_id:, order_date: order_date.to_s, status:, total: }
    end
  end
end
