module Spree
  module ProductImport
    #
    # Task Processor Class
    #
    class Product
      include Spree::ProductImport::ParamsMap

      def initialize(product_data)
        @data = product_data
      end

      def generate
        @product = Spree::Product.find_or_initialize_by(slug: @data[:slug])
        params = remap(required_keys_only)
                 .merge(shipping_category: shipping_category,
                        price: price,
                        sku: sku)
        @product.assign_attributes(params)
        @product.save
        update_stock_total
        @product.id
      end

      def self.generate(product_data)
        new(product_data).generate
      end

      private

      def sku
        @data[:slug].upcase
      end

      def price
        @data[:price].tr(',', '.').to_f if @data[:price]
      end

      def update_taxon
        category = Spree::Taxon.where(name: @data[:category]).first_or_create!
        @product.taxons << category
      end

      def shipping_category
        Spree::ShippingCategory.first
      end

      def required_keys_only
        @data.select { |k, _v| PRODUCT_REQUIRED_PARAMS.keys.include?(k) }
      end

      def location
        StockLocation.first
      end

      def update_stock_total
        stock_item = @product.master
                             .stock_items
                             .first_or_initialize(stock_location: location)
        stock_item.count_on_hand = @data[:stock_total]
        stock_item.save
      end
    end
  end
end
