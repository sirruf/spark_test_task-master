module Spree
  module ImportProducts
    #
    # CSV File parser
    #
    class Process
      require 'csv'
      CSV_SETTINGS = { headers: true,
                       col_sep: ';',
                       converters: :numeric,
                       header_converters: :symbol }.freeze
      REQ_PARAMS_MAP = {
        name: :name,
        description: :description,
        availability_date: :available_on,
        slug: :slug
      }.freeze

      def initialize(task)
        @task = task
        @csv_file = task.filepath
      end

      def parse
        Spree::Product.transaction do
          imported = 0
          ignored = 0
          CSV.foreach(@csv_file, CSV_SETTINGS) do |row|
            csv_data = row.to_hash
            if csv_data[:name].present?
              product = product_from(csv_data)
              product.save! ? imported += 1 : ignored += 1
            end
          end
          @task.update_attributes(imported: imported, ignored: ignored)
        end
      rescue ActiveRecord::RecordInvalid => exception
        @task.update_attributes(error_message: exception)
      end

      def self.process(task)
        new(task).parse
      end

      def product_from(csv_data)
        params = csv_data.map { |k, v| [REQ_PARAMS_MAP[k], v] if REQ_PARAMS_MAP[k] }.compact.to_h
        # { nil => nil, :name => 'Ruby on Rails Bag',
        #   :description => 'Animi officia aut amet molestiae atque excepturi.',
        #   :price => '22,99',
        #   :availability_date => '2017-12-04T14:55:22.913Z',
        #   :slug => 'ruby-on-rails-bag',
        #   :stock_total => 15,
        #   :category => 'Bags' }
        product = Spree::Product.new(params)
        product.shipping_category = Spree::ShippingCategory.first
        product.taxons << Spree::Taxon.find_by(name: csv_data[:category])
        product.price = price_from(csv_data[:price])
        # product.price = csv_data[:price].tr(',', '.').to_f if csv_data[:price]
        product.sku = csv_data[:slug]
        total_count(product, csv_data[:stock_total])
        # product.master.stock_items.first.count_on_hand = csv_data[:stock_total]
        # product.master << Spree::StockItem.new(count_on_hand: csv_data[:stock_total])
        # product.stock_items << Spree::StockItem.new(count_on_hand: csv_data[:stock_total],
        #                                             stock_location: Spree::StockLocation.first,
        #                                             variant: Spree::Variant.new(sku: csv_data[:slug]))
        product
      end

      def price_from(price_string)
        price_string.tr(',', '.').to_f if price_string
      end

      def total_count(product, count)
        stock_item = product.master.stock_items.first_or_initialize
        stock_item.count_on_hand = count
      end

    end
  end
end
