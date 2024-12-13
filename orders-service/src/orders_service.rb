# frozen_string_literal: true

require 'logger'

require_relative 'orders_service/config'
require_relative 'orders_service/repository'
require_relative 'orders_service/order'
require_relative 'orders_service/new_order/contract'
require_relative 'orders_service/new_order/form'
require_relative 'orders_service/validation/error_item'

module OrdersService
  # @return [OrdersService::Repository]
  def self.repo = @repo ||= Repository.new(table: Config.dynamo_table)

  # @return [Logger]
  def self.logger = @logger ||= Logger.new($stdout)

  # @param event [Hash<Object, Object>]
  # @return [OrdersService::NewOrder::Form]
  def self.new_order_form(event:) = NewOrder::Form.new(event:)
end
