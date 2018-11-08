module Spree
  module ProductImport
    module Parsers
      #
      # CSV Product files parser
      #
      class CSV
        require 'csv'
        include Spree::ProductImport::ParamsMap
        CSV_SETTINGS = { headers: true,
                         col_sep: ';',
                         converters: :numeric,
                         header_converters: :symbol }.freeze

        def initialize(filepath)
          @csv_file = filepath
          @stats = { ignored: 0, processed: 0 }
        end

        # Return parser name (must be defined)
        def name
          'CSV'
        end

        # Return parsed data as array of hashes (must be defined)
        def parse
          result = []
          ::CSV.foreach(@csv_file, CSV_SETTINGS) do |row|
            parsed_row = parse_row(row)
            result << parsed_row if parsed_row.present?
          end
          result
        end

        # Checks supported content_type (must be defined)
        def self.support?(content_type)
          content_type == 'text/csv'
        end

        private

        # Return parsed row as hash
        def parse_row(row)
          csv_data = row.to_hash
          if all_required_key?(csv_data)
            @stats[:processed] += 1
            csv_data
          else
            @stats[:ignored] += 1
            nil
          end
        end

        # Checks required keys and values exist
        def all_required_key?(row)
          PRODUCT_REQUIRED_PARAMS.keys
                                 .all? { |k| row.key?(k) && row[k].present? }
        end
      end
    end
  end
end
