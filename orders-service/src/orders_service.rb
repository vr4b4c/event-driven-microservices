# frozen_string_literal: true

require 'logger'

require 'dry-validation'
require 'aws-sdk-dynamodb'
require 'aws-sdk-sqs'

require_relative 'orders_service/config'
require_relative 'orders_service/repository'
require_relative 'orders_service/order'
require_relative 'orders_service/create_order/contract'
require_relative 'orders_service/create_order/form'
require_relative 'orders_service/create_order/result'
require_relative 'orders_service/validation/error_item'

module OrdersService
  class << self
    # @return [OrdersService::Repository]
    def repo = @repo ||= Repository.new(table: Config.dynamo_table)

    # @return [Logger]
    def logger = @logger ||= Logger.new($stdout)

    def sqs_client = @sqs_client ||= Aws::SQS::Client.new(region: region)

    # @param event [Hash<Object, Object>]
    # @return [OrdersService::CreateOrder::Result]
    def create_order(event:)
      form = CreateOrder::Form.new(event:)

      if form.valid?
        order = repo.add(order: form.to_order)
        publish_order_created_event(order:)
        CreateOrder::Result.new(form:, order:)
      else
        CreateOrder::Result.new(form:)
      end
    end

    private

    # @param order [OrdersService::Order]
    # @return [void]
    def publish_order_created_event(order:)
      logger.info('Dispatching order created event...')

      Config.sqs_client.send_message(queue_url: Config.sqs_queue_url,
                                     message_body: order.to_json)
    end
  end
end
