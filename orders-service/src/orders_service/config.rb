# frozen_string_literal: true

module OrdersService
  module Config
    class << self
      # @return [Aws::DynamoDB::Table]
      # @raise [ArgumentError]
      def dynamo_table
        case app_env
        when :dev
          Aws::DynamoDB::Resource.new(
            client: Aws::DynamoDB::Client.new(region: ENV.fetch('DYNAMO_REGION'))
          ).table(ENV.fetch('DYNAMO_TABLE_NAME'))
        when :test
          TestHelpers::DynamoDBTable.instance
        else
          raise ArgumentError, "Invalid app env: #{app_env}"
        end
      end

      # @return [Aws::DynamoDB::Table]
      # @raise [ArgumentError]
      def sqs_client
        case app_env
        when :dev
          Aws::SQS::Client.new(region: ENV.fetch('ORDER_CREATED_QUEUE_REGION'))
        when :test
          TestHelpers::SqsClient.instance
        else
          raise ArgumentError, "Invalid app env: #{app_env}"
        end
      end

      # @return [String]
      # @raise [ArgumentError]
      def sqs_queue_url = ENV.fetch('ORDER_CREATED_QUEUE_URL')

      private

      # @return [Symbol]
      def app_env = @app_env ||= ENV.fetch('APP_ENV').to_sym
    end
  end
end
