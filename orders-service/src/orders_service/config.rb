# frozen_string_literal: true

module OrdersService
  module Config
    # @return [Aws::DynamoDB::Client]
    # @rase [ArgumentError]
    def self.dynamo_client
      case ENV.fetch('ORDERS_SERVICE_APP_ENV')
      when 'production'
        Aws::DynamoDB::Client.new(region: ENV.fetch('ORDERS_SERVICE_DYNAMO_REGION'))
      else
        raise ArgumentError, "Invalid app env: #{ENV.fetch('ORDERS_SERVICE_APP_ENV')}"
      end
    end
  end
end
