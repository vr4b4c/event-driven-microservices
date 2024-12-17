# frozen_string_literal: true

require 'json'

module ReserveInventory
  class OrderCreatedEvent
    # @return [String]
    attr_reader :order_id

    # @param order_id [String]
    def initialize(order_id:)
      @order_id = order_id
    end

    # @param message [String]
    # @return [ReserveInventory::OrderCreatedEvent]
    # @raise [ArgumentError]
    def self.parse(message:)
      data = JSON.parse(message, symbolize_names: true)
      new(order_id: data.fetch(:order_id))
    end
  end
end
