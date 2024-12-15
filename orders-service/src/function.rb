# frozen_string_literal: true

require 'json'

require 'securerandom'
require 'dry-validation'
require 'aws-sdk-dynamodb'

require_relative 'orders_service'

module Function
  class << self
    # @param event [Hash<Object, Object>]
    # @return [Hash<Symbol, Object>]
    def perform(event:, **_) # rubocop:disable Metrics/AbcSize
      OrdersService.logger.info(event.transform_keys(&:to_sym).inspect)
      form = OrdersService.new_order_form(event: new_order_data(event))

      if form.valid?
        OrdersService.logger.info('Creating order...')
        order = OrdersService.repo.add(order: form.to_order)
        { statusCode: 200, body: JSON.generate(data: { order_id: order.order_id }) }
      else
        OrdersService.logger.info('Invalid data received...')
        { statusCode: 400, body: JSON.generate(data: { errors: form.errors.map(&:to_h) }) }
      end
    end

    private

    # @param event [Hash<Object, Object>]
    # @return [Hash<Symbol, Object>]
    def new_order_data(event)
      JSON.parse(event.fetch('body'), symbolize_names: true)
    end
  end
end
