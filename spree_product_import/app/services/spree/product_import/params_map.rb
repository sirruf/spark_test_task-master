module Spree
  module ProductImport
    #
    # Product parameters map
    #
    module ParamsMap
      # Product's required parameters map
      PRODUCT_REQUIRED_PARAMS = {
        name: :name,
        description: :description,
        availability_date: :available_on,
        slug: :slug
      }.freeze

      def remap(hash)
        hash.map do |k, v|
          [PRODUCT_REQUIRED_PARAMS[k], v] if PRODUCT_REQUIRED_PARAMS[k]
        end.to_h
      end
    end
  end
end
