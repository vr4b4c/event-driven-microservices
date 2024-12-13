# frozen_string_literal: true

module OrdersService
  module Config
    # @return [Aws::DynamoDB::Table]
    # @rase [ArgumentError]
    def self.dynamo_table # rubocop:disable Metrics/MethodLength
      case ENV.fetch('ORDERS_SERVICE_APP_ENV')
      when 'production'
        Aws::DynamoDB::Resource.new(
          client: Aws::DynamoDB::Client.new(
            region: ENV.fetch('ORDERS_SERVICE_DYNAMO_REGION')
          )
        ).table(ENV.fetch('ORDERS_SERVICE_DYNAMO_TABLE_NAME'))
      when 'test'
        TestHelpers::DynamoDBTable.instance
      else
        raise ArgumentError, "Invalid app env: #{ENV.fetch('ORDERS_SERVICE_APP_ENV')}"
      end
    end
  end
end
