module Spree
  #
  # Import Task Processing Job
  #
  class ProcessImportJob < ApplicationJob
    def perform(task_id)
      puts "Processing task ##{task_id}"
      task = Spree::ProductImportTask.find(task_id)
      Spree::ProductImport::TaskProcessor.process(task)
    end
  end
end
