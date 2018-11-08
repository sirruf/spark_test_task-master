module Spree
  module Admin
    #
    # Controller for Product files import
    #
    class ProductImportTaskController < ResourceController
      def index
        @product_import_tasks = Spree::ProductImportTask.all.order(id: :desc)
      end

      def create
        task = Spree::ProductImportTask.generate_from(
          products_file_param[:csv_file]
        )
        redirect_to admin_product_import_task_index_path,
                    flash: message_for(task)
      end

      def restart
        @product_import_tasks = Spree::ProductImportTask.find(params[:id])
        result = if @product_import_tasks
                   @product_import_tasks.restart
                 else
                   { error: 'Task not found' }
                 end
        redirect_to admin_product_import_task_index_path,
                    flash: result
      end

      private

      def products_file_param
        params.require(:products).permit(:csv_file)
      end

      def message_for(task)
        if task.errors.present?
          { error: task.errors.full_messages.join(',') }
        else
          { notice: Spree.t('task_in_background') }
        end
      end
    end
  end
end
