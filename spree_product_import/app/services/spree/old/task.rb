module Spree
  module ImportProducts
    #
    # New Product Task generator
    #
    class Task
      def initialize(file_param)
        @file_param = file_param
        @temp_file = @file_param.try(:tempfile)
      end

      def create
        task = Spree::ProductImportTask.new
        if @temp_file.present?
          if @file_param.content_type == 'text/csv'
            task.update_attributes(filename: @file_param.original_filename,
                                   filepath: @temp_file.path,
                                   filesize: @temp_file.length)
          else
            task.errors.add(:base, Spree.t('incorrect_file_type'))
          end
        else
          task.errors.add(:base, Spree.t('csv_file_not_found'))
        end
        task
      end

      def self.create(file_params)
        new(file_params).create
      end
    end
  end
end
