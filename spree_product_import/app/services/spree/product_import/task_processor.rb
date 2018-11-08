module Spree
  module ProductImport
    #
    # Task Processor Class
    #
    class TaskProcessor
      def initialize(task)
        @task = task
        @task.update_attributes(status: :processing)
      end

      def process
        products = []
        parser = Spree::ProductImport::Parser.new(@task)
        parsed_data = parser.parse
        parsed_data.each do |product_data|
          product = Spree::ProductImport::Product.generate(product_data)
          products << product
        end
        @task.update_attributes(status: :complete)
        products
      rescue StandardError => e
        @task.update_attributes(status: :failed, error_message: e.message)
      end

      def self.process(task)
        new(task).process
      end
    end
  end
end