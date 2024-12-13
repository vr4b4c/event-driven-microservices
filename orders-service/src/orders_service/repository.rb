# frozen_string_literal: true

module OrdersService
  class Repository
    # @param table [Aws::DynamoDB::Table]
    def initialize(table:)
      @table = table
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
