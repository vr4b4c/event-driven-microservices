# frozen_string_literal: true

require 'securerandom'
require 'dry-validation'
require 'aws-sdk-dynamodb'

require_relative 'orders_service'

module Handler
  # @param event [Hash<Object, Object>]
  # @return [Hash<Symbol, Object>]
  def self.perform(event:, context:)
    OrdersService.logger.info(event.inspect)
    OrdersService.logger.info(event.transform_keys(&:to_sym).inspect)
    form = OrdersService.new_order_form(event: event.transform_keys(&:to_sym))

    if form.valid?
      OrdersService.logger.info('Creating order...')
      order = OrdersService.repo.add(order: form.to_order)
      { status: :success, data: { order_id: order.order_id } }
    else
      OrdersService.logger.info('Invalid data received...')
      { status: :failure, data: { errors: form.errors.map(&:to_h) } }
    end
  end
end
