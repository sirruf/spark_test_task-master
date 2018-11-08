module Spree
  module ProductImport
    #
    # Base Product files parser Class
    #
    class Parser
      extend Forwardable
      PARSERS = %w[CSV].freeze

      def initialize(task)
        @task = task
        @parser = select_parser(content_type)
        raise StandardError, 'Unsupported products file format' if @parser.nil?
      end

      # Delegate parser's instance methods
      def_delegators :@parser, :name, :parse

      private

      # Select parser by content_type
      def select_parser(content_type)
        parser_class = parser_classes.detect do |c|
          c.support?(content_type)
        end
        parser_class.try(:new, @task.filepath)
      end

      # Get available parsers list
      def parser_classes
        PARSERS.map { |p| Parsers.const_get(p) }
      end

      # Get attachment content_type
      def content_type
        @task.content_type
      end
    end
  end
end
