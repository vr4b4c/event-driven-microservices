# frozen_string_literal: true

require 'logger'

require_relative 'reserve_inventory/order_created_event'

module ReserveInventory
  class << self
    # @return [Logger]
    def logger = @logger ||= Logger.new($stdout)

    # @param message [String]
    # @return [void]
    def process(message:)
      event = OrderCreatedEvent.parse(message:)
      logger.info("Order #{event.order_id} processed")
    end
  end
end
