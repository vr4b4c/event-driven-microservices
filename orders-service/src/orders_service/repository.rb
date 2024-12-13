# frozen_string_literal: true

module OrdersService
  class Repository
    # @param dynamo_client [Aws::DynamoDB::Client]
    def initialize(dynamo_client:)
      @table = Aws::DynamoDB::Resource.new(client: dynamo_client).table(ENV.fetch('ORDERS_SERVICE_DYNAMO_TABLE_NAME'))
    end

    # @param order [OrdersService::Order]
    # @return [OrdersService::Order]
    def add(order:)
      table.put_item(item: order.to_dynamo_item)

      order
    end

    private

    # @return [Aws::DynamoDB::Table]
    attr_reader :table
  end
end
