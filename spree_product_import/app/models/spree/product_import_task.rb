module Spree
  #
  # Product import tasks Class
  #
  class ProductImportTask < ApplicationRecord
    validates :filename, :filepath, presence: true
    after_create :process
    after_update :check_status

    def process
      if process_available?
        Spree::ProcessImportJob.perform_later(id)
      else
        update_attributes(status: :unavailable) unless status == 'complete'
      end
    end

    def restart
      if process_available?
        restart
        { notice: Spree.t('task_restarted') }
      else
        { error: Spree.t('task_couldnt_restart') }
      end
    end

    def process_available?
      filepath.present? && File.exist?(filepath)
    end

    def self.generate_from(attachment)
      task = new
      if attachment.present? && attachment.tempfile.present?
        task.update_attributes(filename: attachment.original_filename,
                               content_type: attachment.content_type,
                               filepath: attachment.tempfile.path,
                               filesize: attachment.tempfile.length)
      else
        task.errors.add(:base, Spree.t('import_file_not_found'))
      end
      task
    end

    private

    def check_status
      status_changes = saved_changes['status']
      clean if status_changes.present? && status_changes[1] == 'complete'
    end

    def clean
      File.delete(filepath) if File.exist?(filepath)
    end
  end
end
