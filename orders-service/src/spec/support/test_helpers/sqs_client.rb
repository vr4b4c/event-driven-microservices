# frozen_string_literal: true

require 'singleton'

module TestHelpers
  class SqsClient
    include ::Singleton

    # @return [Array<TestHelpers::SqsClient::Message>]
    attr_reader :messages

    def initialize
      @messages = []
    end

    # @param queue_url [String]
    # @param message_body [String]
    # @return [void]
    def send_message(queue_url:, message_body:) = messages << Message.new(queue_url:, message_body:)

    # @return [void]
    def reset = @messages = []

    Message = Data.define(:queue_url, :message_body)
    private_constant :Message
  end
end
