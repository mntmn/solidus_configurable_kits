# frozen_string_literal: true

module SolidusConfigurableKits
  class PriceSelector < ::Spree::Variant::PriceSelector
    def self.pricing_options_class
      SolidusConfigurableKits::PricingOptions
    end

    # The variant's Spree::Price record, given a set of pricing options
    # @param [Spree::Variant::PricingOptions] price_options Pricing Options to abide by
    # @return [Spree::Price, nil] The most specific price for this set of pricing options.
    def price_for_options(price_options)
      variant.currently_valid_prices.detect do |price|
        (price.country_iso == price_options.desired_attributes[:country_iso] ||
          price.country_iso.nil?
        ) && price.currency == price_options.desired_attributes[:currency] &&
        price.kit_item == price_options.desired_attributes[:kit_item]
      end
    end
  end
end