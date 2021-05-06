# frozen_string_literal: true

module SolidusConfigurableKits
  class AddKit
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def call(variant, quantity, kit_variant_quantities)
      line_item = order.line_items.new(
        variant: variant,
        quantity: quantity
      )

      kit_variant_quantities.each do |kit_variant, kit_quantity|
        order.line_items.new(
          variant: kit_variant,
          quantity: kit_quantity * quantity,
          kit: line_item
        )
      end

      order.save! # Persist the order with the new line items

      # Handle any promotions
      ::Spree::PromotionHandler::Cart.new(order, line_item).activate
      # Update order totals
      order.recalculate

      line_item
    end
  end
end