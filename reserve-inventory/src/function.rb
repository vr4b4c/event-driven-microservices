# frozen_string_literal: true

require_relative 'reserve_inventory'

module Function
  class << self
    # @param event [Hash<Object, Object>]
    # @return [Hash<Symbol, Object>]
    def perform(event:, **_)
      ReserveInventory.logger.info('Processing OrderCreated event: started')
      ReserveInventory.logger.info("event: #{event.inspect}")
      event['Records'].each do |record|
        ReserveInventory.process(message: record.fetch('body'))
      end
      ReserveInventory.logger.info('Processing OrderCreated event: done')
    end
  end
end
