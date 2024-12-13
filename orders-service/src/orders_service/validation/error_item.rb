# frozen_string_literal: true

module OrdersService
  module Validation
    class ErrorItem
      # @return [Array<Symbol>]
      attr_reader :path

      # @return [String]
      attr_reader :message

      # @param path [Array<Symbol>]
      # @param message [String]
      def initialize(path:, message:)
        @path = path
        @message = message
      end

      # @return [Hash<Symbol, Object>]
      def to_h = { path:, message: }

      # @param schema_message [Dry::Schema::Message]
      # @return [OrdersService::Validation::ErrorItem]
      def self.parse(schema_message)
        new(path: schema_message.path, message: schema_message.text)
      end
    end
  end
end
